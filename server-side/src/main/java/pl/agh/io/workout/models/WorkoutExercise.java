package pl.agh.io.workout.models;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import pl.agh.io.exercise.models.Exercise;

import javax.persistence.*;

@Entity
@Table(name = "workout_exercises")
@IdClass(WorkoutExerciseId.class)
@JsonPropertyOrder({"workoutId", "exerciseId","series", "reps"})
public class WorkoutExercise {
    @Id
    @ManyToOne
    @PrimaryKeyJoinColumn(name="workout_id", referencedColumnName="id")
    private Workout workout;

    @Id
    @ManyToOne
    @PrimaryKeyJoinColumn(name="exercise_id", referencedColumnName="id")
    private Exercise exercise;

    public int getWorkoutId(){
        return workout.getId();
    }

    public int getExerciseId(){
        return exercise.getId();
    }

    @Column(name="series")
    private int series;

    @Column(name="reps")
    private int reps;

    public int getSeries(){
        return this.series;
    }

    public int getReps() {
        return this.reps;
    }
}
