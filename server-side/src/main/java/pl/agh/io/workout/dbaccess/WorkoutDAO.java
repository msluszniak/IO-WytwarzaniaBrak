package pl.agh.io.workout.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pl.agh.io.workout.models.Workout;
import pl.agh.io.workout.models.WorkoutExercise;

import java.util.*;
import java.util.stream.Collectors;

@Component
public class WorkoutDAO {
    private final WorkoutRepository workoutRepository;

    @Autowired
    public WorkoutDAO(WorkoutRepository workoutRepository) {
        this.workoutRepository = workoutRepository;
    }

    public List<Workout> getAllWorkouts() {
        List<Workout> workouts = new ArrayList<>();
        workoutRepository.findAll().forEach(workouts::add);
        return workouts;
    }

    public List<WorkoutExercise> getAllWorkoutExercises() {
        List<Workout> workouts = new ArrayList<>();
        workoutRepository.findAll().forEach(workouts::add);

        List<WorkoutExercise> workoutExercises = new ArrayList<>();
        for (Workout workout : workouts) {
            workoutExercises.addAll(workout.getExercises().stream()
                    .map(e -> new WorkoutExercise(workout.getId(), e.getId())).collect(Collectors.toList()));
        }
        return workoutExercises;
    }
}