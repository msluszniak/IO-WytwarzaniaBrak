package pl.agh.io.workout.models;

public class WorkoutExercise {
    private Integer workoutId;
    private Integer exerciseId;

    public WorkoutExercise(Integer workoutId, Integer exerciseId) {
        this.workoutId = workoutId;
        this.exerciseId = exerciseId;
    }

    public Integer getWorkoutId() {
        return workoutId;
    }

    public void setWorkoutId(Integer workoutId) {
        this.workoutId = workoutId;
    }

    public Integer getExerciseId() {
        return exerciseId;
    }

    public void setExerciseId(Integer exerciseId) {
        this.exerciseId = exerciseId;
    }
}
