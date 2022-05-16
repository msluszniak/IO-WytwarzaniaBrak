package pl.agh.io.equipment.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pl.agh.io.equipment.models.Equipment;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
public class EquipmentDAO {
    private final EquipmentRepository equipmentRepository;

    @Autowired
    public EquipmentDAO(EquipmentRepository equipmentRepository) { this.equipmentRepository = equipmentRepository;
    }

    public List<Equipment> getAllEquipments() {
        List<Equipment> equipments = new ArrayList<>();
        equipmentRepository.findAll().forEach(equipments::add);
        return equipments;
    }

    public Equipment getEquipmentById(Integer Id) {
        Optional<Equipment> equipment = equipmentRepository.findById(Id);
        if(equipment.isPresent())
            return equipment.get();
        else
            throw new IllegalArgumentException("No equipment with this id exists");
    }
}