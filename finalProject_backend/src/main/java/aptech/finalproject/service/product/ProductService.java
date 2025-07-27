package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.ProductRequest;
import aptech.finalproject.dto.response.product.ProductResponse;
import aptech.finalproject.entity.product.Equipment;
import aptech.finalproject.entity.product.Promotion;
import aptech.finalproject.entity.product.Supplement;
import aptech.finalproject.entity.product.Supplier;

import java.util.List;

public interface ProductService {
    ProductResponse createProduct(ProductRequest productRequest);

    ProductResponse updateProduct(Long productId, ProductRequest productRequest);

    void deleteProduct(Long productId);

    ProductResponse getProductById(Long productId);

    List<ProductResponse> getProductsByName(String productName);

    List<ProductResponse> getAllProducts();

    List<ProductResponse> getProductsBySupplier(Supplier supplier);

    List<ProductResponse> getProductsByEquipment(Equipment equipment);

    List<ProductResponse> getProductsBySupplement(Supplement supplement);
}
