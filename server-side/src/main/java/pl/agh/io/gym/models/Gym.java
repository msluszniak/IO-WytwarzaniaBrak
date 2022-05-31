package pl.agh.io.gym.models;

import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.models.Exercise;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity(name="gym")
public class Gym {
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer id;

    private String name;
    private Double latitude;
    private Double longitude;
    private String description;
    private String address;

    @ManyToMany(
            fetch = FetchType.EAGER,
            cascade = {CascadeType.MERGE, CascadeType.PERSIST}
    )
    @JoinTable(
            name = "gyms_equipments",
            joinColumns = @JoinColumn(name = "gym_id"),
            inverseJoinColumns = @JoinColumn(name = "equipment_id")
    )
    private final Set<Equipment> equipment = new HashSet<>();

    public Set<Equipment> getEquipment() {
        return equipment;
    }

    public Gym(int i, String name1, double v, double v1, String des, String s) {
        this.name = name1;
        this.id = i;
        this.latitude = v;
        this.longitude = v1;
        this.description = des;
        this.address = s;
    }

    public Gym() {

    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Gym{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", description='" + description + '\'' +
                ", address='" + address + '\'' +
                ", equipment=" + equipment +
                '}';
    }
}

