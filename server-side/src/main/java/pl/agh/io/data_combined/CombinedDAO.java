package pl.agh.io.data_combined;

import org.hibernate.ObjectNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pl.agh.io.equipment.dbaccess.EquipmentDAO;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.dbaccess.ExerciseDAO;
import pl.agh.io.exercise.models.Exercise;
import pl.agh.io.gym.dbaccess.GymDAO;
import pl.agh.io.gym.models.Gym;

import java.util.*;
import java.util.stream.Collectors;

@Component
public class CombinedDAO {
    @Autowired
    private GymDAO gymDAO;

    @Autowired
    private ExerciseDAO exerciseDAO;

    @Autowired
    private EquipmentDAO equipmentDAO;

    public Map<Gym, Set<Equipment>> getMapGymSetOfEquipment(List<Integer> exerciseIds) {
        List<Gym> gyms = gymDAO.getAllGyms();
        Map<Gym, Set<Equipment>> mapGymEqs = new HashMap<>();

        List<Equipment> equipments = new ArrayList<>();
        for(Integer id : exerciseIds)
            try {
                equipments.add(equipmentDAO.getEquipmentById(exerciseDAO.getExerciseById(id).getEquipmentId()));
            } catch(ObjectNotFoundException e) {
                System.out.println(e.getLocalizedMessage());
            }

        for(Gym gym : gyms) {
            Set<Integer> gymEquipmentIds = gym.getEquipment().stream().map(Equipment::getId).collect(Collectors.toSet());
            Set<Equipment> equipmentForSearch = new HashSet<>();

            for(Equipment equipment : equipments)
                if(gymEquipmentIds.contains(equipment.getId()))
                    equipmentForSearch.add(equipment);

            if(!equipmentForSearch.isEmpty())
                mapGymEqs.put(gym, equipmentForSearch);
        }
        return mapGymEqs;
    }

    public Map<Exercise, Equipment> getMapExerciseEquipment(List<Integer> exerciseIds) {
        Map<Exercise, Equipment> mapExEq = new HashMap<>();
        Exercise exercise;
        for(Integer id : exerciseIds) {
            try {
                exercise = exerciseDAO.getExerciseById(id);
                mapExEq.put(exercise, equipmentDAO.getEquipmentById(exercise.getEquipmentId()));
            } catch(ObjectNotFoundException e) {
                System.out.println(e.getLocalizedMessage());
            }
        }
        return mapExEq;
    }
}
