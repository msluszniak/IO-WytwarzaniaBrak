package pl.agh.io.exercise.models;

import pl.agh.io.workout.models.Workout;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity(name="exercises")
public class Exercise {
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer id;
    private String name;
    private String bodyPart;
    @Column(name="equipment_id")
    private Integer equipmentId;
    private String description;

    @Transient
    private boolean isFavorite = false;

    @ManyToMany(fetch = FetchType.EAGER, mappedBy = "exercises")
    private Set<Workout> workouts = new HashSet<>();

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

    public String getBodyPart() {
        return bodyPart;
    }

    public void setBodyPart(String bodyPart) {
        this.bodyPart = bodyPart;
    }

    public Integer getEquipmentId() {
        return equipmentId;
    }

    public void setEquipmentId(Integer equipment_id) {
        this.equipmentId = equipment_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isFavorite() {
        return isFavorite;
    }

    public void setFavorite(boolean favorite) {
        isFavorite = favorite;
    }
}