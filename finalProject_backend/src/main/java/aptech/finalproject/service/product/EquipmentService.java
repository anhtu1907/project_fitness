package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.EquipmentRequest;
import aptech.finalproject.dto.response.product.EquipmentResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface EquipmentService {
    EquipmentResponse createEquipment(EquipmentRequest equipmentRequest);

    EquipmentResponse updateEquipment(Long id, EquipmentRequest equipmentRequest);

    void deleteEquipment(Long id);

    EquipmentResponse getEquipmentById(Long id);

    List<EquipmentResponse> getAllEquipments(Pageable pageable);
}
