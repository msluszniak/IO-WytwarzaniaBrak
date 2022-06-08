package pl.agh.io.workout.models;

import java.io.Serializable;
import java.util.Objects;

public class WorkoutExerciseId implements Serializable {
    private int workout;
    private int exercise;

    public void setExercise(int exercise) {
        this.exercise = exercise;
    }

    public void setWorkoutId(int workoutId) {
        this.workout = workoutId;
    }

    public int getExercise() {
        return exercise;
    }

    public int getWorkoutId() {
        return workout;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WorkoutExerciseId that = (WorkoutExerciseId) o;
        return workout == that.workout && exercise == that.exercise;
    }

    @Override
    public int hashCode() {
        return Objects.hash(workout, exercise);
    }
}
