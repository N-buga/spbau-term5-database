import javax.persistence.*;

@Entity
@Table(name="RC")
public class ReviewsCharacteristics {
    @Column
    @GeneratedValue
    @Id
    private Integer id;

    @Column
    private String name;


    public ReviewsCharacteristics(String name) {
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "ReviewsCharacteristics{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
