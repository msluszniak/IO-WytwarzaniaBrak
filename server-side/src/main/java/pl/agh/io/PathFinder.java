package pl.agh.io;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import pl.agh.io.gym.models.Gym;

public class PathFinder {
    private final int workoutId;
    private Set<Integer> exercisesIds = new HashSet<>();
    private Set<Integer> equipmentsIds = new HashSet<>();

    public PathFinder(int workoutId){
        this.workoutId = workoutId;
    }

    public ArrayList<Integer> findGyms(ArrayList<Gym> gyms){
        Set<Integer> currentEquipmentsIds = new HashSet<>(equipmentsIds);
        ArrayList<Integer> result = new ArrayList<>();
        for(Gym gym: gyms){
            Set<Integer> intersection = new HashSet<Integer>(gym.equipments); // use the copy constructor
            intersection.retainAll(currentEquipmentsIds);
            if (intersection.size() > 0) {
                result.add(gym.getId());
                for(Integer equipmentId: intersection) {
                    currentEquipmentsIds.remove(equipmentId);
                }
            }
        }
        return result;
    }
}