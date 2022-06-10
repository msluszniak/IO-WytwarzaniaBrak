package pl.agh.io.exercise.dbaccess;

import org.hibernate.ObjectNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.models.Exercise;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
public class ExerciseDAO {
    @Autowired
    private ExerciseRepository exerciseRepository;


    public List<Exercise> getAllExercises() {
        List<Exercise> exercises = new ArrayList<>();
        exerciseRepository.findAll().forEach(exercises::add);
        return exercises;
    }

    public Exercise getExerciseById(Integer id) {
        Optional<Exercise> maybeGym = exerciseRepository.findById(id);
        if(maybeGym.isPresent())
            return maybeGym.get();
        else
            throw new ObjectNotFoundException(id, "Exercise");
    }
}