package pl.agh.io.workout.dbaccess;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.agh.io.workout.models.Workout;
import pl.agh.io.workout.models.WorkoutExercise;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping(path = "/workout")
public class WorkoutDBAccessController {
    private final WorkoutDAO workoutDAO;

    @Autowired
    public WorkoutDBAccessController(WorkoutDAO workoutDAO) {
        this.workoutDAO = workoutDAO;
    }

    @GetMapping(path = "/all")
    public @ResponseBody
    List<Workout> getAllWorkouts() {
        Map<Integer, Workout> workouts = workoutDAO.getAllWorkouts().stream().collect(Collectors.toMap(Workout::getId, item -> item));

        return new ArrayList<>(workouts.values());
    }

    @GetMapping(path = "/all_exercises")
    public @ResponseBody
    List<WorkoutExercise> getAllWorkoutExercises() {
        return workoutDAO.getAllWorkoutExercises();
    }
}

