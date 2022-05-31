package pl.agh.io.data_combined;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.exercise.models.Exercise;
import pl.agh.io.gym.models.Gym;

import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping(path="/combined")
public class CombinedController {
    private final CombinedDAO combinedDAO;

    @Autowired
    public CombinedController(CombinedDAO combinedDAO) {
        this.combinedDAO = combinedDAO;
    }

    @GetMapping(path ="/gyms")
    public @ResponseBody Map<Gym, Set<Equipment>> getGyms(@RequestParam List<Integer> ids){
        return combinedDAO.getGymsWithEquipments(ids);
    }

    @GetMapping(path="/exercises")
    public @ResponseBody Map<Exercise, Equipment> getExercises(@RequestParam List<Integer> ids) {
        return combinedDAO.getExercisesWithEquipments(ids);
    }
}