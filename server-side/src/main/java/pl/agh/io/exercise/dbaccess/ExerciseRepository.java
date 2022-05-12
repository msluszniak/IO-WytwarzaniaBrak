package pl.agh.io.exercise.dbaccess;


import org.springframework.data.repository.CrudRepository;
import pl.agh.io.exercise.models.Exercise;

public interface ExerciseRepository extends CrudRepository<Exercise, Integer> {
}
