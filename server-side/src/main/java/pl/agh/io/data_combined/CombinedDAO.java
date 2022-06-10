package pl.agh.io.data_combined;

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

    public Map<Integer, Set<Integer>> getMapGymSetOfEquipment(List<Integer> exerciseIds) {
        List<Gym> gyms = gymDAO.getAllGyms();
        Map<Integer, Set<Integer>> mapGymEqs = new HashMap<>();

        List<Integer> equipmentIds = exerciseDAO.getExerciseByIds(exerciseIds).stream().map(Exercise::getEquipmentId).collect(Collectors.toList());
        List<Equipment> equipments = equipmentDAO.getEquipmentByIds(equipmentIds);

        for(Gym gym : gyms) {
            Set<Integer> gymEquipmentIds = gym.getEquipment().stream().map(Equipment::getId).collect(Collectors.toSet());
            Set<Integer> equipmentForSearch = new HashSet<>();

            for(Equipment equipment : equipments)
                if(gymEquipmentIds.contains(equipment.getId()))
                    equipmentForSearch.add(equipment.getId());

            if(!equipmentForSearch.isEmpty())
                mapGymEqs.put(gym.getId(), equipmentForSearch);
        }
        return mapGymEqs;
    }

    public Map<Integer, Integer> getMapExerciseEquipment(List<Integer> exerciseIds) {
        Map<Integer, Integer> mapExEq = new HashMap<>();
        exerciseDAO.getExerciseByIds(exerciseIds).forEach(exercise -> mapExEq.put(exercise.getId(), exercise.getEquipmentId()));
        return mapExEq;
    }
}

