// This class is a part of the 4th "sprint" of the database labs
// running in Saint-Petersburg Academic University in Fall'16
//
// Author: Dmitry Barashev
// License: WTFPL

import com.j256.ormlite.field.DatabaseField;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * Entity object corresponding to a single row in Accomodations table
 */


@Entity
public class Accomodations {
  @Column
  @GeneratedValue
  @Id
  private Integer id;

  @Column
  private Integer user_id;

  @Column
  private String address;

  @Column
  private String gps;

  @Column
  private String description;

  @Column
  private Integer rooms_amount;

  @Column
  private Integer beds_amount;

  @Column
  private Integer max_residents;

  @Column(name="clening_cost")
  private Integer cleaning_cost;

  @DatabaseField(foreign=true, foreignAutoRefresh = true, columnName = "country_id")
  private Countries countries;

  // Required by ORM
  public Accomodations() {}

  public Accomodations(Integer user_id, String address, String gps, String description,
                       Integer rooms_amount, Integer beds_amount, Integer max_residents, Integer cleaning_cost,
                       Countries countries) {
    this.user_id = user_id;
    this.address = address;
    this.gps = gps;
    this.description = description;
    this.rooms_amount = rooms_amount;
    this.beds_amount = beds_amount;
    this.max_residents = max_residents;
    this.cleaning_cost = cleaning_cost;
      this.countries = countries;
  }

  @Override
  public String toString() {
    final StringBuffer sb = new StringBuffer("Accomodations{");
    sb.append("name='").append(description).append('\'');
    sb.append(", country='").append(countries.getName()).append('\'');
    sb.append(", rooms_amount=").append(rooms_amount);
    sb.append(", beds_amount=").append(beds_amount);
    sb.append(", max_residents=").append(max_residents);
    sb.append('}');
    return sb.toString();
  }

  public Integer getUser_id() {
    return user_id;
  }

  public Integer getCountry_id() {
    return countries.getId();
  }

  public String getAddress() {
    return address;
  }

  public String getGps() {
    return gps;
  }

  public String getDescription() {
    return description;
  }

  public Integer getRooms_amount() {
    return rooms_amount;
  }

  public Integer getBeds_amount() {
    return beds_amount;
  }

  public Integer getMax_residents() {
    return max_residents;
  }

  public Integer getCleaning_cost() {
    return cleaning_cost;
  }
}
