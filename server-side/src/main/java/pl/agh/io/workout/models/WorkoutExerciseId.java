package pl.agh.io.workout.models;

import java.io.Serializable;
import java.util.Objects;

public class WorkoutExerciseId implements Serializable {
    private int workoutId;
    private int exerciseId;

    public void setExerciseId(int exerciseId) {
        this.exerciseId = exerciseId;
    }

    public void setWorkoutId(int workoutId) {
        this.workoutId = workoutId;
    }

    public int getExerciseId() {
        return exerciseId;
    }

    public int getWorkoutId() {
        return workoutId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WorkoutExerciseId that = (WorkoutExerciseId) o;
        return workoutId == that.workoutId && exerciseId == that.exerciseId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(workoutId, exerciseId);
    }
}
