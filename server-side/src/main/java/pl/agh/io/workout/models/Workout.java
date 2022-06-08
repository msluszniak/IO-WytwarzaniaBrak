package pl.agh.io.workout.models;

import pl.agh.io.exercise.models.Exercise;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity(name="workouts")
public class Workout {
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer id;
    private String name;

    @OneToMany(mappedBy = "workout")
    private Set<WorkoutExercise> exercises = new HashSet<>();

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

    public Set<WorkoutExercise> getExercises(){
        return exercises;
    }
}
