package pl.agh.io.workout.dbaccess;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.agh.io.exercise.models.Exercise;
import pl.agh.io.workout.models.Workout;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping(path="/workout")
public class WorkoutDBAccessController {
    private final WorkoutDAO workoutDAO;

    @Autowired
    public WorkoutDBAccessController(WorkoutDAO workoutDAO) {
        this.workoutDAO = workoutDAO;
    }

    @GetMapping(path="/all")
    public @ResponseBody List<Workout> getAllWorkouts(@RequestParam("favorite_ids") Integer [] favouriteIds) {
        Map<Integer, Workout> workouts = workoutDAO.getAllWorkouts().stream().collect(Collectors.toMap(Workout::getId, item -> item));

        for(Integer favId: favouriteIds)
            if(workouts.containsKey(favId))
                workouts.get(favId).setFavorite(true);

        return new ArrayList<>(workouts.values());
    }

    @GetMapping(path="/all_exercises")
    public @ResponseBody Map<Integer, Set<Exercise>> getAllWorkoutExercises() {
        return workoutDAO.getAllWorkoutExercises();
    }
}

