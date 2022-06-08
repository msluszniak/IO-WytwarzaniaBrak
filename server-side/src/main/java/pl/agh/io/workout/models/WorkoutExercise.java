package pl.agh.io.workout.models;

import pl.agh.io.exercise.models.Exercise;

import javax.persistence.*;

@Entity
@Table(name = "workout_exercises")
@IdClass(WorkoutExerciseId.class)
public class WorkoutExercise {
    @Id
    private int workoutId;

    @Id
    private int exerciseId;

    @ManyToOne
    @PrimaryKeyJoinColumn(name="workout_id", referencedColumnName="id")
    private Workout workout;
    @ManyToOne
    @PrimaryKeyJoinColumn(name="exercise_id", referencedColumnName="id")
    private Exercise exercise;

    public Integer getWorkoutId() {
        return workoutId;
    }

    public Integer getExerciseId() {
        return exerciseId;
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

    public WorkoutExercise(int workoutId, int exerciseId, int series, int reps) {
        this.workoutId = workoutId;
        this.exerciseId = exerciseId;
        this.series = series;
        this.reps = reps;
    }

}
