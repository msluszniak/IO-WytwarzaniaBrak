package pl.agh.io.equipment.models;

import pl.agh.io.exercise.models.Exercise;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity(name = "equipments")
public class Equipment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    private String name;

    public Integer getId() {return id;}

    public String getName() {return name;}

    @Override
    public String toString() {
        return "Equipment{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
