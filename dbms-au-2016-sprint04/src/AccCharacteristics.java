import com.j256.ormlite.field.DatabaseField;

import javax.persistence.*;

/**
 * Created by n_buga on 09.12.16.
 */

@Entity
public class AccCharacteristics {
    @Column
    @GeneratedValue
    @Id
    private Integer id;

    @Column
    private Integer mark;

    @Column
    private String comment;

    @DatabaseField(foreign=true, foreignAutoRefresh = true, columnName = "characteristic_id")
    private ReviewsCharacteristics characteristic_id;

    @DatabaseField(foreign=true, foreignAutoRefresh = true, columnName = "review_id")
    private ReviewsAccomodation review_id;

    public AccCharacteristics()
    {}

    public AccCharacteristics(Integer id, Integer mark, String comment, ReviewsCharacteristics characteristic_id, ReviewsAccomodation review_id) {
        this.id = id;
        this.mark = mark;
        this.comment = comment;
        this.characteristic_id = characteristic_id;
        this.review_id = review_id;
    }

    public Integer getId() {
        return id;
    }

    public Integer getMark() {
        return mark;
    }

    public String getComment() {
        return comment;
    }

    public ReviewsCharacteristics getCharacteristic_id() {
        return characteristic_id;
    }

    public ReviewsAccomodation getReview_id() {
        return review_id;
    }

    @Override
    public String toString() {
        return "AccCharacteristics{" +
                "id=" + id +
                ", mark=" + mark +
                ", comment='" + comment + '\'' +
                ", characteristic_id=" + characteristic_id +
                ", review_id=" + review_id +
                '}';
    }
}
