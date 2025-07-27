package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.SCategoryRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.SCategoryResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.SCategoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/scategory")
public class SCategoryController {
    @Autowired
    private SCategoryService sCategoryService;

    @PostMapping("/create")
    public ApiResponse<SCategoryResponse> create(@RequestBody @Valid SCategoryRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        SCategoryResponse created = sCategoryService.createSCategory(request);
        return ApiResponse.created(created, "Created SCategory");
    }

    @GetMapping()
    public ApiResponse<List<SCategoryResponse>> getAll() {
        List<SCategoryResponse> list = sCategoryService.getAllSCategory();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.SCATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all SCategory");
    }

    @GetMapping("/{id}")
    public ApiResponse<SCategoryResponse> getById(@PathVariable Long id) {
        SCategoryResponse response = sCategoryService.getSCategoryById(id);
        return ApiResponse.ok(response, "Get SCategory by ID");
    }

    @PutMapping("/{id}")
    public ApiResponse<SCategoryResponse> update(@PathVariable Long id,
                                                 @RequestBody @Valid SCategoryRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        SCategoryResponse updated = sCategoryService.updateSCategory(id, request);
        return ApiResponse.ok(updated, "Updated SCategory");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        sCategoryService.deleteSCategory(id);
        return ApiResponse.noContent("Deleted SCategory with id: " + id);
    }
}
