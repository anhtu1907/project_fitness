package aptech.finalproject.mapper;

import aptech.finalproject.dto.product.ProductWithPromotionDTO;
import aptech.finalproject.dto.request.product.PromotionRequest;
import aptech.finalproject.dto.response.product.PromotionResponse;
import aptech.finalproject.entity.product.Product;
import aptech.finalproject.entity.product.Promotion;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface PromotionMapper {

    // Convert từ entity sang response
    @Mapping(target = "products", expression = "java(mapProducts(promotion))")
    PromotionResponse toPromotionResponse(Promotion promotion);

    // Convert từ request sang entity (tạo mới)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "productPromotions", ignore = true)
    Promotion toPromotion(PromotionRequest promotionRequest);

    // Cập nhật entity
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "productPromotions", ignore = true)
    void updatePromotion(@MappingTarget Promotion promotion, PromotionRequest promotionRequest);

    // Mapping ProductPromotion → ProductWithPromotionDTO
    default Set<ProductWithPromotionDTO> mapProducts(Promotion promotion) {
        if (promotion.getProductPromotions() == null) return Set.of();

        return promotion.getProductPromotions().stream()
                .map(pp -> ProductWithPromotionDTO.builder()
                        .productId(pp.getProduct().getId())
                        .productName(pp.getProduct().getName())
                        .price(pp.getProduct().getPrice())
                        .discountOverride(pp.getDiscountOverride())
                        .startDate(pp.getStartDate())
                        .endDate(pp.getEndDate())
                        .build())
                .collect(Collectors.toSet());
    }
}
