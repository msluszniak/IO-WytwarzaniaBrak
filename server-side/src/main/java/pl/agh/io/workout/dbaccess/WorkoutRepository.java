package pl.agh.io.workout.dbaccess;

import org.springframework.data.repository.CrudRepository;
import pl.agh.io.workout.models.Workout;

public interface WorkoutRepository extends CrudRepository<Workout, Integer> {
}
