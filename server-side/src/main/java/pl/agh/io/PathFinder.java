package pl.agh.io;
import java.util.*;

import pl.agh.io.gym.models.Gym;


// symulacja działania wyliczania drogi dla zadanego treningu.
// Musimy mieć dostęp do wszystkich siłowni (gyms)
// Następnie potrzebujemy zrobić mapping id_siłowni => lista sprzętów na nim dostępna (gymToEquipmentIds)
// Potrzebujemu także wyłuskać wszystkie możliwe do wykonania ćwiczenia dla zadanego sprzętu (equipmentIdToListOfPossibleExercises)



public class PathFinder {
    private final int workoutId = 6;
    List<Integer> listExercises = Arrays.asList(0,1,2,3,4,5,6,7,8,9,10,11,12);
    private Set<Integer> exercisesIds = new HashSet<>(listExercises);
    List<Integer> listEquipment = Arrays.asList(0,1,2,3,4,5,6,7,8,9,10,11,12);
    private Set<Integer> equipmentsIds = new HashSet<>(listEquipment);
    private Map<Integer, List<Integer>> gymToEquipmentIds = new HashMap<Integer, List<Integer>>();
    private Map<Integer, List<Integer>> equipmentIdToListOfPossibleExercises = new HashMap<Integer, List<Integer>>();

    private final List<Gym> gyms = new ArrayList<>();
    Gym gym1 = new Gym(1, "name1", 1.0, 1.0, "des", "Ul. Losowa 1");
    Gym gym2 = new Gym(2, "name2", 2.0, 2.0, "des", "Ul. Losowa 2");
    Gym gym3 =new Gym(3, "name3", 3.0, 2.0, "des", "Ul. Losowa 3");
    Gym gym4 =new Gym(4, "name4", 4.0, 2.0, "des", "Ul. Losowa 4");
    Gym gym5 =new Gym(5, "name5", 5.0, 2.0, "des", "Ul. Losowa 5");


    public List<Integer> generateRandomArray(int n, int bound){
        ArrayList<Integer> list = new ArrayList<Integer>(n);
        Random random = new Random();

        for (int i = 0; i < n; i++)
        {
            list.add(random.nextInt(bound));
        }
        return list;
    }

    public PathFinder(int workoutId){
        //this.workoutId = workoutId;
        gyms.add(gym1);
        gyms.add(gym2);
        gyms.add(gym3);
        gyms.add(gym4);
        gyms.add(gym5);
        for (Gym gym : gyms){
            List<Integer> equipments = generateRandomArray(5, 12+1);
            gymToEquipmentIds.put(gym.getId(), equipments);
        }
        for (Integer equipmentId : equipmentsIds){
            List<Integer>  exercises = generateRandomArray(3, 12+1);
            equipmentIdToListOfPossibleExercises.put(equipmentId, exercises);
        }
    }

    public List<String> findGyms(){
        Set<Integer> currentExercisesIds = new HashSet<>(exercisesIds);
        ArrayList<Gym> result = new ArrayList<>();
        for(Gym gym: gyms){
            if(currentExercisesIds.isEmpty()){
                break;
            }
            List<Integer> equipments = gymToEquipmentIds.get(gym.getId());
            Set<Integer> intersection = new HashSet<Integer>();
            for (Integer equipment : equipments){
                List<Integer> exercises = equipmentIdToListOfPossibleExercises.get(equipment);
                intersection.addAll(exercises);
            }
            intersection.retainAll(currentExercisesIds);
            if (intersection.size() > 0) {
                result.add(gym);
                for(Integer exerciseId: intersection) {
                    currentExercisesIds.remove(exerciseId);
                }
            }
        }
        if(!currentExercisesIds.isEmpty()){
            System.out.println("Nie udalo sie znalezc silowni dla wszystkich cwiczen z danego treningu");
        }
        List<String> addresses= new ArrayList<String>();
        for (Gym gym : result){
            addresses.add(gym.getAddress());
        }
        return addresses;
    }
}