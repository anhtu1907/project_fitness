package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.ProductRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.ProductResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.ProductMapper;
import aptech.finalproject.service.product.ProductService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product")
public class ProductController {
    @Autowired
    private ProductService productService;

    @Autowired
    private ProductMapper productMapper;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ProductResponse> create(@ModelAttribute @Valid ProductRequest productRequest,
                                               BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ProductResponse product = productService.createProduct(productRequest);
        if (product == null) {
            return ApiResponse.badRequest(ErrorCode.PRODUCT_CREATION_FAILED.getException());
        }
        return ApiResponse.created(product, "Created product");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ProductResponse> update(@PathVariable Long id,
                                               @ModelAttribute @Valid ProductRequest productRequest,
                                               BindingResult result) {
        System.out.println("id: " + id);
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ProductResponse updated = productService.updateProduct(id, productRequest);

        if (updated == null) {
            return ApiResponse.notFound(ErrorCode.PRODUCT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(updated, "Updated product");
    }

    @GetMapping()
    public ApiResponse<List<ProductResponse>> getAll() {
        List<ProductResponse> products = productService.getAllProducts();
        if (products.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PRODUCT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(products, "Get all products");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ProductResponse> getById(@PathVariable Long id) {
        ProductResponse product = productService.getProductById(id);
        if (product == null) {
            return ApiResponse.notFound(ErrorCode.PRODUCT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(product, "Get product by id");
    }

    @GetMapping("/name/{name}")
    public ApiResponse<List<ProductResponse>> getByName(@PathVariable String name) {
        List<ProductResponse> products = productService.getProductsByName(name);
        if (products.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PRODUCT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(products, "Get products by name");
    }


    @DeleteMapping("/{id}")
    public ApiResponse<ProductResponse> delete(@PathVariable Long id) {
        try {
            productService.deleteProduct(id);
            return ApiResponse.noContent(String.format("Deleted product with id %s", id));
        } catch (DataIntegrityViolationException e) {
            return ApiResponse.badRequest("Cannot delete product due to related orders or constraints");
        } catch (Exception e) {
            return ApiResponse.badRequest("Unexpected error while deleting product");
        }
    }
}
