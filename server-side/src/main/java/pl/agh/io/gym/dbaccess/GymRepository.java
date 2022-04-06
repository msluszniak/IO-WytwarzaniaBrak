package pl.agh.io.gym.dbaccess;

import org.springframework.data.repository.CrudRepository;
import pl.agh.io.gym.models.Gym;

public interface GymRepository extends CrudRepository<Gym, Integer> {
}
