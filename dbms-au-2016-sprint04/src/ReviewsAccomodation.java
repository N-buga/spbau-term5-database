import com.j256.ormlite.field.DatabaseField;

import javax.persistence.*;

/**
 * Created by Admin on 10.12.2016.
 */

@Entity
@Table(name="RA")
public class ReviewsAccomodation {
    @Column
    @GeneratedValue
    @Id
    private Integer id;
    
    @Column
    private String review;
    
    @Column
    private Integer user_id;
    
    @Column
    private String reviewed_at;
    
    @DatabaseField(foreign = true, foreignAutoRefresh = true, columnName = "accomodation_id")
    private Accomodations accomodation_id;

    public ReviewsAccomodation(String review, Integer user_id, String reviewed_at, Accomodations accomodation_id) {
        this.review = review;
        this.user_id = user_id;
        this.reviewed_at = reviewed_at;
        this.accomodation_id = accomodation_id;
    }

    public Integer getId() {
        return id;
    }

    public String getReview() {
        return review;
    }

    public Integer getUser_id() {
        return user_id;
    }

    public String getReviewed_at() {
        return reviewed_at;
    }

    public Accomodations getAccomodation_id() {
        return accomodation_id;
    }

    @Override
    public String toString() {
        return "ReviewsAccomodation{" +
                "id=" + id +
                ", review='" + review + '\'' +
                ", user_id=" + user_id +
                ", reviewed_at='" + reviewed_at + '\'' +
                ", accomodation_id=" + accomodation_id +
                '}';
    }
}
