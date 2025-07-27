package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.SupplierRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.SupplierResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.SupplierService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/supplier")
public class SupplierController {
    @Autowired
    private SupplierService supplierService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<SupplierResponse> create(@ModelAttribute @Valid SupplierRequest request,
                                                BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        SupplierResponse created = supplierService.createSupplier(request);
        return ApiResponse.created(created, "Created Supplier");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<SupplierResponse> update(@PathVariable Long id,
                                                @ModelAttribute @Valid SupplierRequest request,
                                                BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        SupplierResponse updated = supplierService.updateSupplier(id, request);
        return ApiResponse.ok(updated, "Updated Supplier");
    }

    @GetMapping()
    public ApiResponse<List<SupplierResponse>> getAll() {
        List<SupplierResponse> list = supplierService.getAllSuppliers();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.SUPPLIER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all Suppliers");
    }

    @GetMapping("/{id}")
    public ApiResponse<SupplierResponse> getById(@PathVariable Long id) {
        SupplierResponse response = supplierService.getById(id);
        return ApiResponse.ok(response, "Get Supplier by ID");
    }



    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        supplierService.deleteById(id);
        return ApiResponse.noContent("Deleted Supplier with id: " + id);
    }
}
