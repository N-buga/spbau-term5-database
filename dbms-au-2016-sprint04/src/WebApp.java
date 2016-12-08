// This class is a part of the 4th "sprint" of the database labs
// running in Saint-Petersburg Academic University in Fall'16
//
// Author: Dmitry Barashev
// License: WTFPL

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.misc.TransactionManager;
import com.j256.ormlite.support.DatabaseConnection;
import spark.Request;
import spark.Response;
import spark.Route;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.stream.Collectors;

import static spark.Spark.get;
import static spark.Spark.port;

public class WebApp {
  static JdbcConnectionSource createConnectionSource() {
    try {
      JdbcConnectionSource connectionSource = new JdbcConnectionSource("jdbc:postgresql://localhost:5432/postgres?user=postgres&password=postgres");
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
      List<String> spacecrafts = DaoManager.createDao(connectionSource, Accomodations.class)
          .queryForAll().stream()
          .map(s -> s.toString()).collect(Collectors.toList());
      return String.join("\n", spacecrafts);
    });
  }

  private static Object newAccomodations(Request req, Response resp) throws IOException, SQLException {
    final JdbcConnectionSource connectionSource = createConnectionSource();
    Object success = runTxn("READ COMMITTED", connectionSource, () -> {
      Dao<Accomodations, Integer> spacecraftDao = DaoManager.createDao(connectionSource, Accomodations.class);
      Accomodations newAccomodations = new Accomodations(
              req.queryMap("user_id").integerValue(),
              req.queryMap("country_id").integerValue(),
              req.queryMap("address").value(),
              req.queryMap("gps").value(),
              req.queryMap("description").value(),
              req.queryMap("rooms_amount").integerValue(),
              req.queryMap("beds_amounts").integerValue(),
              req.queryMap("max_residents").integerValue(),
              req.queryMap("cleaning_cost").integerValue());
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
    get("/apartment/new", WebApp.withTry(WebApp::newAccomodations));
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
