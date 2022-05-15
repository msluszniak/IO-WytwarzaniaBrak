package pl.agh.io.exercise.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.models.Exercise;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
public class ExerciseDAO {
    private final ExerciseRepository exerciseRepository;

    @Autowired
    public ExerciseDAO(ExerciseRepository exerciseRepository) {
        this.exerciseRepository = exerciseRepository;
    }

    public List<Exercise> getAllExercises() {
        List<Exercise> exercises = new ArrayList<>();
        exerciseRepository.findAll().forEach(exercises::add);
        return exercises;
    }
}