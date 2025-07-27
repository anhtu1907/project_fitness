package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.ECategoryRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.ECategoryResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.ECategoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ecategory")
public class ECategoryController {
    @Autowired
    private ECategoryService eCategoryService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ECategoryResponse> create(@ModelAttribute @Valid ECategoryRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ECategoryResponse response = eCategoryService.createECategory(request);
        if (response == null) {
            return ApiResponse.badRequest(ErrorCode.ECATEGORY_CREATION_FAILED.getException());
        }
        return ApiResponse.created(response, "Created equipment category");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ECategoryResponse> update(@PathVariable Long id,
                                                 @ModelAttribute @Valid ECategoryRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ECategoryResponse updated = eCategoryService.updateECategory(id, request);
        if (updated == null) {
            return ApiResponse.notFound(ErrorCode.ECATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(updated, "Updated equipment category");
    }

    @GetMapping
    public ApiResponse<List<ECategoryResponse>> getAll() {
        List<ECategoryResponse> list = eCategoryService.getAllCategories();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.ECATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all equipment categories");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ECategoryResponse> getById(@PathVariable Long id) {
        ECategoryResponse response = eCategoryService.getCategoryById(id);
        if (response == null) {
            return ApiResponse.notFound(ErrorCode.ECATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(response, "Get equipment category by id");
    }


    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        eCategoryService.deleteECategory(id);
        return ApiResponse.noContent("Deleted equipment category with id " + id);
    }
}
