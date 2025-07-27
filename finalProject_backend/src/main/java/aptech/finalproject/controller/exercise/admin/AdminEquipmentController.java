package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.EquipmentsRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.EquipmentsResponse;

import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminEquipmentService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/equipment")
public class AdminEquipmentController {

    @Autowired
    private AdminEquipmentService equipmentService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<EquipmentsResponse> create(@ModelAttribute @Valid EquipmentsRequest request,
                                                  BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        EquipmentsResponse response = equipmentService.createEquipment(request);
        if (response == null) {
            return ApiResponse.badRequest(ErrorCode.EQUIPMENT_CREATION_FAILED.getException());
        }

        return ApiResponse.created(response, "Created equipment");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<EquipmentsResponse> update(@PathVariable int id,
                                                  @ModelAttribute @Valid EquipmentsRequest request,
                                                  BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        EquipmentsResponse response = equipmentService.updateEquipment(id, request);
        return ApiResponse.ok(response, "Updated equipment");
    }

    @GetMapping
    public ApiResponse<List<EquipmentsResponse>> getAll() {
        List<EquipmentsResponse> list = equipmentService.getAllEquipments();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EQUIPMENT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all equipments");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<EquipmentsResponse> getById(@PathVariable int id) {
        EquipmentsResponse response = equipmentService.getEquipmentById(id);
        return ApiResponse.ok(response, "Get equipment by id");
    }

    @GetMapping("/name/{name}")
    public ApiResponse<List<EquipmentsResponse>> getByName(@PathVariable String name) {
        List<EquipmentsResponse> list = equipmentService.searchEquipmentsByName(name);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EQUIPMENT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get equipment by name");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        equipmentService.deleteEquipment(id);
        return ApiResponse.noContent(String.format("Deleted equipment with id %s", id));
    }

    @GetMapping("/{id}/exercise-count")
    public ApiResponse<Long> countExercisesByEquipment(@PathVariable int id) {
        long count = equipmentService.countExercisesByEquipmentId(id);
        return ApiResponse.ok(count, "Number of exercises linked to equipment " + id);
    }
}