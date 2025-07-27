package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.SupplementRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.SupplementResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.SupplementService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/supplement")
public class SupplementController {
    @Autowired
    private SupplementService supplementService;

    @PostMapping("/create")
    public ApiResponse<SupplementResponse> create(@RequestBody @Valid SupplementRequest request,
                                                  BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        SupplementResponse created = supplementService.createSupplement(request);
        return ApiResponse.created(created, "Created Supplement");
    }

    @GetMapping()
    public ApiResponse<List<SupplementResponse>> getAll() {
        List<SupplementResponse> list = supplementService.getAllSupplements();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.SUPPLEMENT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all Supplements");
    }

    @GetMapping("/{id}")
    public ApiResponse<SupplementResponse> getById(@PathVariable Long id) {
        SupplementResponse response = supplementService.getSupplementById(id);
        return ApiResponse.ok(response, "Get Supplement by ID");
    }

    @PutMapping("/{id}")
    public ApiResponse<SupplementResponse> update(@PathVariable Long id,
                                                  @RequestBody @Valid SupplementRequest request,
                                                  BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        SupplementResponse updated = supplementService.updateSupplement(id, request);
        return ApiResponse.ok(updated, "Updated Supplement");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        supplementService.deleteSupplement(id);
        return ApiResponse.noContent("Deleted Supplement with id: " + id);
    }
}
