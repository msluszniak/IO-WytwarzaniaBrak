package pl.agh.io.data_combined;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.agh.io.PlannedWorkout;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.dbaccess.ExerciseDAO;
import pl.agh.io.exercise.models.Exercise;
import pl.agh.io.gym.dbaccess.GymDAO;
import pl.agh.io.gym.models.Gym;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.*;

@Controller
@RequestMapping(path = "/combined")
public class CombinedController {
    private final CombinedDAO combinedDAO;

    @Autowired
    private GymDAO gymDAO = new GymDAO();

    @Autowired
    private ExerciseDAO exerciseDAO = new ExerciseDAO();

    @Autowired
    public CombinedController(CombinedDAO combinedDAO) {
        this.combinedDAO = combinedDAO;
    }

    @GetMapping(path = "/gyms")
    public @ResponseBody
    Map<Integer, Set<Integer>> getGyms(@RequestParam List<Integer> ids) {
        return combinedDAO.getMapGymSetOfEquipment(ids);
    }

    @GetMapping(path = "/exercises")
    public @ResponseBody
    Map<Integer, Integer> getExercises(@RequestParam List<Integer> ids) {
        return combinedDAO.getMapExerciseEquipment(ids);
    }

    @GetMapping(path = "/findPath")
    public @ResponseBody
    PlannedWorkout findPath(@RequestParam List<Integer> exercisesIds) {
        Set<Integer> currentExercises = new HashSet<>(exercisesIds);
        List<Gym> resultGyms = new ArrayList<>();
        List<List<Exercise>> resultExercises = new ArrayList<>();
        List<Gym> gyms = gymDAO.getAllGyms();
        Map<Integer, Set<Integer>> mapGymSetOfEquipment = combinedDAO.getMapGymSetOfEquipment(exercisesIds);
        Map<Integer, Integer> mapExerciseEquipment = combinedDAO.getMapExerciseEquipment(exercisesIds);
        for (Gym gym : gyms) {
            if (currentExercises.isEmpty()) {
                break;
            }
            Set<Integer> equipments = mapGymSetOfEquipment.get(gym.getId());
            if(equipments == null)
                continue;
            boolean ifAddedGym = false;
            List<Exercise> exercisesAdded = new ArrayList<>();
            for (Integer exerciseId : currentExercises) {
                Integer equipmentId = mapExerciseEquipment.get(exerciseId);
                if (equipments.contains(equipmentId)) {
                    if (!ifAddedGym) {
                        ifAddedGym = true;
                    }
                    exercisesAdded.add(exerciseDAO.getExerciseById(exerciseId));
                }
            }
            if (ifAddedGym) {
                resultGyms.add(gym);
                resultExercises.add(exercisesAdded);
                for (Exercise e : exercisesAdded) {
                    currentExercises.remove(e.getId());
                }
            }
        }
        if (!currentExercises.isEmpty()) {
            System.out.println("Nie udalo sie znalezc silowni dla wszystkich cwiczen z danego treningu");
        }
        return new PlannedWorkout(resultGyms, resultExercises);
    }
}