package pl.agh.io;

import pl.agh.io.exercise.models.Exercise;
import pl.agh.io.gym.models.Gym;

import java.util.List;

public class PlannedWorkout {
    private final List<Gym> gymsToVisit;
    private final List<List<Exercise>> exercisesOnGyms;

    public PlannedWorkout(List<Gym> gymsToVisit, List<List<Exercise>> exercisesOnGyms) {
        this.gymsToVisit = gymsToVisit;
        this.exercisesOnGyms = exercisesOnGyms;
    }

    public List<Gym> getGymsToVisit() {
        return gymsToVisit;
    }

    public List<List<Exercise>> getExercisesOnGyms() {
        return exercisesOnGyms;
    }
}
