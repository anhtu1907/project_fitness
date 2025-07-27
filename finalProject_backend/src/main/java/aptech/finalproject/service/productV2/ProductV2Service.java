 package aptech.finalproject.service.productV2;

 import aptech.finalproject.dto.productV2.EquipmentDTO;
 import aptech.finalproject.dto.productV2.ProductCardDTO;
 import aptech.finalproject.dto.productV2.SupplementDTO;
 import aptech.finalproject.dto.response.product.ECategoryResponse;
 import aptech.finalproject.dto.response.product.EquipmentResponse;
 import aptech.finalproject.dto.response.product.SCategoryResponse;
 import aptech.finalproject.dto.response.product.SupplementResponse;

 import java.util.List;


 public interface ProductV2Service {
     List<ProductCardDTO> getProductCards();

     List<ECategoryResponse> getECategories();

     List<SCategoryResponse> getSCategories();

     EquipmentDTO getEquipmentById(Long id);

     SupplementDTO getSupplementById(Long id);

     List<ProductCardDTO> getProductTopCards(Long limit);
 }
