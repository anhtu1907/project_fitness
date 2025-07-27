package aptech.finalproject.mapper;

import aptech.finalproject.dto.product.ProductPromotionDTO;
import aptech.finalproject.dto.request.product.ProductRequest;
import aptech.finalproject.dto.response.product.ProductResponse;
import aptech.finalproject.entity.product.Product;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;
import java.util.stream.Collectors;

@Mapper( componentModel = "spring")
public interface ProductMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "supplier", ignore = true)
    @Mapping(target = "productPromotions", ignore = true)
    @Mapping(target = "equipment", ignore = true)
    @Mapping(target = "supplement", ignore = true)
    @Mapping(target = "category", ignore = true)
    Product toProduct(ProductRequest productRequest);

    @Mapping(source = "image.storedName", target = "image")
    @Mapping(source = "supplier.id", target = "supplier")
    @Mapping(source = "equipment.id", target = "equipment")
    @Mapping(source = "supplement.id", target = "supplement")
    @Mapping(target = "promotions", expression = "java(mapPromotions(product))")
    ProductResponse toProductResponse(Product product);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "supplier", ignore = true)
    @Mapping(target = "productPromotions", ignore = true)
    @Mapping(target = "equipment", ignore = true)
    @Mapping(target = "supplement", ignore = true)
    @Mapping(target = "category", ignore = true)
    void updateProduct(@MappingTarget Product product, ProductRequest productRequest);

    default List<ProductPromotionDTO> mapPromotions(Product product) {
        if (product.getProductPromotions() == null) return List.of();

        return product.getProductPromotions().stream()
                .distinct()
                .map(pp -> ProductPromotionDTO.builder()
                        .promotionId(pp.getPromotion().getId())
                        .promotionName(pp.getPromotion().getName())
                        .discountOverride(pp.getDiscountOverride())
                        .startDate(pp.getStartDate())
                        .endDate(pp.getEndDate())
                        .build())
                .collect(Collectors.toList());
    }
}
