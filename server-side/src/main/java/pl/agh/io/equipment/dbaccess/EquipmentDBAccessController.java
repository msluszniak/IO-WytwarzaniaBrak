package pl.agh.io.equipment.dbaccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.agh.io.equipment.models.Equipment;
import pl.agh.io.equipment.dbaccess.EquipmentDAO;
import pl.agh.io.gym.models.Gym;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping(path="/equipment")
public class EquipmentDBAccessController {
    private final EquipmentDAO equipmentDAO;

    @Autowired
    public EquipmentDBAccessController(EquipmentDAO equipmentDAO) {
        this.equipmentDAO = equipmentDAO;
    }

    @GetMapping(path ="/all")
    public List<Equipment> getAll(){
        return equipmentDAO.getAllEquipments();
    }

    @GetMapping(path="/{Id}")
    public @ResponseBody
    Equipment getEquipmentById(@PathVariable Integer Id) {
        try {
            return equipmentDAO.getEquipmentById(Id);
        } catch(IllegalArgumentException e) {
            return null;
        }
    }
}