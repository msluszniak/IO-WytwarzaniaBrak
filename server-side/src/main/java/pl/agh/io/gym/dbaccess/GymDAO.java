package pl.agh.io.gym.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.gym.models.Gym;
import pl.agh.io.gym.models.GymEquipment;
import pl.agh.io.workout.models.Workout;
import pl.agh.io.workout.models.WorkoutExercise;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
public class GymDAO {
    @Autowired
    private GymRepository gymRepository;

    public void addNewGym(String name, Double latitude, Double longitude, String description, String address) {
        Gym gym = new Gym();
        gym.setName(name);
        gym.setLatitude(latitude);
        gym.setLongitude(longitude);
        gym.setDescription(description);
        gym.setAddress(address);

        gymRepository.save(gym);
    }

    public void deleteGymById(Integer Id) {
        gymRepository.deleteById(Id);
    }

    public void updateGym(Integer Id, String name, Double latitude, Double longitude, String description, String address) {
        if(gymRepository.existsById(Id)) {
            Gym gym = new Gym();
            gym.setId(Id);
            gym.setName(name);
            gym.setLatitude(latitude);
            gym.setLongitude(longitude);
            gym.setDescription(description);
            gym.setAddress(address);

            gymRepository.save(gym);
        } else
            throw new IllegalArgumentException("No gym with this id exists");
    }

    public Gym getGymById(Integer Id) {
        Optional<Gym> gym = gymRepository.findById(Id);
        if(gym.isPresent())
            return gym.get();
        else
            throw new IllegalArgumentException("No gym with this id exists");
    }

    public List<Gym> getAllGyms() {
        List<Gym> gyms = new ArrayList<>();
        gymRepository.findAll().forEach(gyms::add);
        return gyms;
    }

    public List<Gym> getAllGymsByName(String name) {
        List<Gym> gyms = new ArrayList<>();
        gymRepository.findAll().forEach(gym -> {
            if(gym.getName().equals(name))
                gyms.add(gym);
        });
        return gyms;
    }

    public List<GymEquipment> getAllGymEquipments() {
        List<Gym> gyms = new ArrayList<>();
        gymRepository.findAll().forEach(gyms::add);

        List<GymEquipment> gymEquipments = new ArrayList<>();
        for (Gym gym : gyms) {
            for (Equipment equipment : gym.getEquipment()){
                gymEquipments.add(new GymEquipment(gym.getId(), equipment.getId()));
            }
        }

        return gymEquipments;
    }
}
