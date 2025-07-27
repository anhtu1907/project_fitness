package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.EquipmentsRequest;
import aptech.finalproject.dto.response.exercise.EquipmentsResponse;

import java.util.List;

public interface AdminEquipmentService {
    EquipmentsResponse createEquipment(EquipmentsRequest request);
    EquipmentsResponse updateEquipment(int id, EquipmentsRequest request);
    EquipmentsResponse getEquipmentById(int id);
    List<EquipmentsResponse> getAllEquipments();
    List<EquipmentsResponse> searchEquipmentsByName(String name);
    void deleteEquipment(int id);

    Long countExercisesByEquipmentId(int equipmentId);
}
