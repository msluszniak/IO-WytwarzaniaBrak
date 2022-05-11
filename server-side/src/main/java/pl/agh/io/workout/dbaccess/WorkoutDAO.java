package pl.agh.io.workout.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestParam;
import pl.agh.io.exercise.dbaccess.ExerciseRepository;
import pl.agh.io.exercise.models.Exercise;
import pl.agh.io.gym.models.Gym;
import pl.agh.io.workout.models.Workout;

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

    public Map<Integer, Set<Exercise>> getAllWorkoutExercises(){
        List<Workout> workouts = new ArrayList<>();
        workoutRepository.findAll().forEach(workouts::add);

        Map<Integer, Set<Exercise>> workoutExercises = new HashMap<>();
        for (Workout workout : workouts){
            workoutExercises.put(workout.getId(), workout.getExercises());
        }
        return workoutExercises;
    }
}