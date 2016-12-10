// This class is a part of the 4th "sprint" of the database labs
// running in Saint-Petersburg Academic University in Fall'16
//
// Author: Dmitry Barashev
// License: WTFPL

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.dao.GenericRawResults;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.misc.TransactionManager;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.support.DatabaseConnection;
import spark.Request;
import spark.Response;
import spark.Route;

import javax.persistence.ColumnResult;
import javax.persistence.EntityResult;
import javax.persistence.FieldResult;
import javax.persistence.SqlResultSetMapping;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.Callable;
import java.util.stream.Collectors;

import static spark.Spark.get;
import static spark.Spark.port;

public class WebApp {
  static JdbcConnectionSource createConnectionSource() {
    try {
      JdbcConnectionSource connectionSource = new JdbcConnectionSource("jdbc:postgresql://localhost:5432/postgres?user=anta&password=7578757");
      connectionSource.getReadWriteConnection(null).setAutoCommit(false);
      return connectionSource;
    } catch (SQLException e) {
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }

  private static Object runTxn(String isolationLevel, JdbcConnectionSource connectionSource, Callable<Object> code)
      throws SQLException, IOException {
    try {
      DatabaseConnection connection = connectionSource.getReadWriteConnection(null);
      Callable<Object> txnWrapper = () -> {
        connection.executeStatement(
            "set transaction isolation level " + isolationLevel, DatabaseConnection.DEFAULT_RESULT_FLAGS);
        Object result = code.call();
        connection.commit(null);
        return result;
      };
      return TransactionManager.callInTransaction(
          connection, false, new ProxyDatabaseType(connectionSource.getDatabaseType()), txnWrapper);
    } finally {
      connectionSource.close();
    }
  }

  private static Object getAllAccomodations(Request req, Response resp) throws IOException, SQLException {
    final JdbcConnectionSource connectionSource = createConnectionSource();
    resp.type("text/plain");
    return runTxn("REPEATABLE READ", connectionSource, () -> {
      Dao<Accomodations, ?> accDao = DaoManager.createDao(connectionSource, Accomodations.class);
      Dao<Countries, ?> countryDao = DaoManager.createDao(connectionSource, Countries.class);
      QueryBuilder<Accomodations, ?> accQB = accDao.queryBuilder();
      QueryBuilder<Countries, ?> countryQB = countryDao.queryBuilder();
      accQB.join(countryQB);
        List<String> accomodations = accQB.query().stream().map(Accomodations::toString).collect(Collectors.toList());
        return String.join("\n", accomodations);
    });
  }

  private static Object getAllCountries(Request req, Response resp) throws IOException, SQLException {
    final JdbcConnectionSource connectionSource = createConnectionSource();
    resp.type("text/plain");
    return runTxn("REPEATABLE READ", connectionSource, () -> {
      List<String> countries = DaoManager.createDao(connectionSource, Countries.class)
              .queryForAll().stream()
              .map(s -> s.toString()).collect(Collectors.toList());
      return String.join("\n", countries);
    });
  }

    /*private static Object getAllReviewsAcc(Request req, Response resp) throws IOException, SQLException {
        final JdbcConnectionSource connectionSource = createConnectionSource();
        resp.type("text/plain");
        return runTxn("REPEATABLE READ", connectionSource, () -> {
            Dao<Accomodations, ?> accDao = DaoManager.createDao(connectionSource, Accomodations.class);
            Dao<Countries, ?> countryDao = DaoManager.createDao(connectionSource, Countries.class);
            Dao<ReviewsAccomodation, ?> reviewsAccDao = DaoManager
                    .createDao(connectionSource, ReviewsAccomodation.class);
            Dao<AccCharacteristics, ?> accCharacteristicsDao = DaoManager
                    .createDao(connectionSource, AccCharacteristics.class);
            Dao<ReviewsCharacteristics, ?> reviewsCharacteristicsDao = DaoManager
                    .createDao(connectionSource, ReviewsCharacteristics.class);

            QueryBuilder<Accomodations, ?> accQB = accDao.queryBuilder();
            QueryBuilder<Countries, ?> countryQB = countryDao.queryBuilder();
            QueryBuilder<ReviewsAccomodation, ?> reviewsAccQB = reviewsAccDao.queryBuilder();
            QueryBuilder<AccCharacteristics, ?> accCharQB = accCharacteristicsDao.queryBuilder();
            QueryBuilder<ReviewsCharacteristics, ?> reviewsCharQB = reviewsCharacteristicsDao.queryBuilder();

            accQB.join(countryQB);
            reviewsAccQB.join(accQB);
            accCharQB.join(reviewsAccQB);
            accCharQB.join(reviewsCharQB);

            Dao<AllAccReviews, ?> all = DaoManager.createDao(connectionSource, AllAccReviews.class);
            GenericRawResults<String[]> accomodationsReview = all.queryRaw("SELECT acc.id, rc.name, AVG(ac.mark) " +
                    "FROM Accomodations acc " +
                    "JOIN ReviewsAccomodation ra on acc.id = ra.accomodation_id" +
                    "JOIN AccCharacteristics ac on ac.review_id = ra.id" +
                    "JOIN ReviewsCharacteristics rc on rc.id = ac.characteristic_id" +
                    "GROUP BY acc.id, rc.name");

            StringBuffer sb = new StringBuffer();
            for (String[] resultArray : accomodationsReview) {
                sb.append("Accomodation " + resultArray[0] + " on characteristic "
                        + resultArray[1] + " have average mark " + resultArray[2] + '\n');
            }
            accomodationsReview.close();

            return sb.toString();
        });
    }*/


  private static Object newAccomodations(Request req, Response resp) throws IOException, SQLException {
    final JdbcConnectionSource connectionSource = createConnectionSource();
    Object success = runTxn("READ COMMITTED", connectionSource, () -> {
        Countries country;
        Dao<Countries, ?> countryDao = DaoManager.createDao(connectionSource, Countries.class);
        List<Countries> list = countryDao.queryForEq("name", req.queryMap("country").value());
        if (list.size() == 0) {
            resp.status(418);
            return String.format("Wrong country name '%s'!", req.queryMap("country").value());
        }
        country = list.get(0);
        Dao<Accomodations, Integer> spacecraftDao = DaoManager.createDao(connectionSource, Accomodations.class);
      Accomodations newAccomodations = new Accomodations(
              null,
              null,
              null,
              req.queryMap("name").value(),
              req.queryMap("rooms").integerValue(),
              req.queryMap("beds").integerValue(),
              req.queryMap("guests").integerValue(),
              null,
              country);
      spacecraftDao.create(newAccomodations);
      return true;
    });
    if (Boolean.TRUE.equals(success)) {
      resp.redirect("/apartment/all");
      return null;
    }
    resp.status(500);
    return "Transaction failed";
  }

  public static void main(String[] args) {
    port(8000);
    get("/apartment/all", WebApp.withTry(WebApp::getAllAccomodations));
    get("/countries/all", WebApp.withTry(WebApp::getAllCountries));
    get("/apartment/new", WebApp.withTry(WebApp::newAccomodations));
    //get("/apartment/reviewsall", WebApp.withTry(WebApp::getAllReviewsAcc));
  }

  private static Route withTry(Route route) {
    return (req, resp) -> {
      try {
        return route.handle(req, resp);
      } catch (Throwable e) {
        e.printStackTrace();
        resp.status(500);
        return e.getMessage();
      }
    };
  }
}
