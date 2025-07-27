package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.EquipmentRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.EquipmentResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.EquipmentService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/equipment")
public class EquipmentController {
    @Autowired
    private EquipmentService equipmentService;

    @PostMapping("/create")
    public ApiResponse<EquipmentResponse> create(@RequestBody @Valid EquipmentRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        EquipmentResponse created = equipmentService.createEquipment(request);
        return ApiResponse.created(created, "Created Equipment");
    }

    @GetMapping
    public ApiResponse<List<EquipmentResponse>> getAll(Pageable pageable) {
        List<EquipmentResponse> list = equipmentService.getAllEquipments(pageable);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EQUIPMENT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all Equipment with pagination");
    }

    @GetMapping("/{id}")
    public ApiResponse<EquipmentResponse> getById(@PathVariable Long id) {
        EquipmentResponse response = equipmentService.getEquipmentById(id);
        return ApiResponse.ok(response, "Get Equipment by ID");
    }

    @PutMapping("/{id}")
    public ApiResponse<EquipmentResponse> update(@PathVariable Long id,
                                                 @RequestBody @Valid EquipmentRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        EquipmentResponse updated = equipmentService.updateEquipment(id, request);
        return ApiResponse.ok(updated, "Updated Equipment");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        equipmentService.deleteEquipment(id);
        return ApiResponse.noContent("Deleted Equipment with id: " + id);
    }
}
