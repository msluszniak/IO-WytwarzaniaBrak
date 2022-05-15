package pl.agh.io.equipment.dbaccess;

import org.springframework.data.repository.CrudRepository;
import pl.agh.io.equipment.models.Equipment;

public interface EquipmentRepository extends CrudRepository<Equipment, Integer> {
}
