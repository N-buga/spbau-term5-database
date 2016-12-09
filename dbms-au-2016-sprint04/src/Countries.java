import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * Created by n_buga on 08.12.16.
 */
public class Countries {
    @Column
    @Id
    @GeneratedValue
    private Integer id;

    @Column
    private String name;

    @Column
    private Integer commission;


    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Integer getCommission() {
        return commission;
    }

    // Required by ORM
    public Countries() {}

    public Countries(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        final StringBuffer sb = new StringBuffer("Countries{");
        sb.append("id=").append(id);
        sb.append(", name='").append(name).append('\'');
        sb.append(", commission=").append(commission);
        sb.append('}');
        return sb.toString();
    }
}
