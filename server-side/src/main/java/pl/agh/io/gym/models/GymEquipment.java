package pl.agh.io.gym.models;

public class GymEquipment {
    private int gymId;
    private int equipmentId;

    public GymEquipment(int gymId, int equipmentId) {
        this.gymId = gymId;
        this.equipmentId = equipmentId;
    }

    public void setGymId(int gymId) {
        this.gymId = gymId;
    }

    public void setEquipmentId(int equipmentId) {
        this.equipmentId = equipmentId;
    }

    public int getGymId() {
        return gymId;
    }

    public int getEquipmentId() {
        return equipmentId;
    }
}
