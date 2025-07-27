 package aptech.finalproject.controller.productV2;

 import aptech.finalproject.dto.productV2.EquipmentDTO;
 import aptech.finalproject.dto.productV2.ProductCardDTO;
 import aptech.finalproject.dto.productV2.SupplementDTO;
 import aptech.finalproject.dto.response.ApiResponse;
 import aptech.finalproject.dto.response.product.ECategoryResponse;
 import aptech.finalproject.dto.response.product.EquipmentResponse;
 import aptech.finalproject.dto.response.product.SCategoryResponse;
 import aptech.finalproject.dto.response.product.SupplementResponse;
 import aptech.finalproject.exception.ErrorCode;
 import aptech.finalproject.service.product.ECategoryService;
 import aptech.finalproject.service.product.SCategoryService;
 import aptech.finalproject.service.productV2.ProductV2Service;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.PathVariable;
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RestController;

 import java.util.List;

 @RestController
 @RequestMapping("/api/productV2")
 public class ProductV2Controller {
     @Autowired
     ProductV2Service productV2Service;

     @GetMapping("/cards")
     public ApiResponse<List<ProductCardDTO>> getProductCards() {
         List<ProductCardDTO> list = productV2Service.getProductCards();
         if (list.isEmpty()) {
             return ApiResponse.notFound(ErrorCode.PRODUCT_NOT_FOUND.getException());
         }
         return ApiResponse.ok(list, "Get all equipment categories");
     }

     @GetMapping("/top/{limit}")
     public ApiResponse<List<ProductCardDTO>> getProductTopCards(@PathVariable Long limit) {
         List<ProductCardDTO> list = productV2Service.getProductTopCards(limit);
         if (list.isEmpty()) {
             return ApiResponse.notFound(ErrorCode.PRODUCT_NOT_FOUND.getException());
         }
         return ApiResponse.ok(list, "Get all equipment categories");
     }

     @GetMapping("/ecategory")
     public ApiResponse<List<ECategoryResponse>> getECategories() {
         List<ECategoryResponse> list = productV2Service.getECategories();
         if (list.isEmpty()) {
             return ApiResponse.notFound(ErrorCode.ECATEGORY_NOT_FOUND.getException());
         }
         return ApiResponse.ok(list, "Get all equipment categories");
     }

     @GetMapping("/scategory")
     public ApiResponse<List<SCategoryResponse>> getSCategories() {
         List<SCategoryResponse> list = productV2Service.getSCategories();
         if (list.isEmpty()) {
             return ApiResponse.notFound(ErrorCode.ECATEGORY_NOT_FOUND.getException());
         }
         return ApiResponse.ok(list, "Get all equipment categories");
     }

     @GetMapping("/equipment/{id}")
     public ApiResponse<EquipmentDTO> getEquitmentById(@PathVariable Long id) {
         EquipmentDTO response = productV2Service.getEquipmentById(id);
         return ApiResponse.ok(response, "Get Equipment by ID");
     }

     @GetMapping("/supplement/{id}")
     public ApiResponse<SupplementDTO> getSupplementById(@PathVariable Long id) {
         SupplementDTO response = productV2Service.getSupplementById(id);
         return ApiResponse.ok(response, "Get Supplement by ID");
     }
 }
