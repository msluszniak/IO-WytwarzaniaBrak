package pl.agh.io.gym.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import pl.agh.io.gym.models.Gym;
import pl.agh.io.gym.models.GymEquipment;
import pl.agh.io.workout.models.WorkoutExercise;

import java.util.List;

@Controller
@RequestMapping(path="/gym")
public class GymDBAccessController {
    @Autowired
    private GymDAO gymDAO;

    @PostMapping(path="/add")
    public @ResponseBody String addNewGym(@RequestParam String name,
                                          @RequestParam Double latitude,
                                          @RequestParam Double longitude,
                                          @RequestParam String description,
                                          @RequestParam String address) {
        try {
            gymDAO.addNewGym(name, latitude, longitude, description, address);
        } catch(IllegalArgumentException e) {
            return e.getMessage();
        }
        return "Gym added successfully";
    }

    @DeleteMapping(path="/delete")
    public @ResponseBody String deleteGym(@RequestParam Integer Id) {
        try {
            gymDAO.deleteGymById(Id);
        } catch(IllegalArgumentException | EmptyResultDataAccessException e) {
            return e.getMessage();
        }
        return "Gym deleted successfully";
    }

    @PutMapping(path="/update")
    public @ResponseBody String updateGym(@RequestParam Integer Id,
                                          @RequestParam String name,
                                          @RequestParam Double latitude,
                                          @RequestParam Double longitude,
                                          @RequestParam String description,
                                          @RequestParam String address) {
        try {
            gymDAO.updateGym(Id, name, latitude, longitude, description, address);
        } catch(IllegalArgumentException e) {
            return e.getMessage();
        }
        return "Gym updated successfully";
    }

    @GetMapping(path="/{Id}")
    public @ResponseBody Gym getGymById(@PathVariable Integer Id) {
        try {
            return gymDAO.getGymById(Id);
        } catch(IllegalArgumentException e) {
            return null;
        }
    }

    @GetMapping(path="/all")
    public @ResponseBody List<Gym> getAllGyms() {
        return gymDAO.getAllGyms();
    }

    @GetMapping(path="/all/{name}")
    public @ResponseBody List<Gym> getAllGymsByName(@PathVariable String name) {
        return gymDAO.getAllGymsByName(name);
    }

    @GetMapping(path = "/all_equipments")
    public @ResponseBody
    List<GymEquipment> getAllWorkoutExercises() {
        return gymDAO.getAllGymEquipments();
    }
}
