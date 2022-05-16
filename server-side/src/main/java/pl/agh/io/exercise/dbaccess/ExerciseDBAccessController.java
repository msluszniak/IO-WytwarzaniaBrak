package pl.agh.io.exercise.dbaccess;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.models.Exercise;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping(path = "/exercise")
public class ExerciseDBAccessController {
    private final ExerciseDAO exerciseDAO;

    @Autowired
    public ExerciseDBAccessController(ExerciseDAO exerciseDAO) {
        this.exerciseDAO = exerciseDAO;
    }

    @GetMapping(path = "/all")
    public @ResponseBody
    List<Exercise> getAllExercises() {
        Map<Integer, Exercise> exercises = exerciseDAO.getAllExercises().stream().collect(Collectors.toMap(Exercise::getId, item -> item));
        return new ArrayList<>(exercises.values());
    }
}

