package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.PromotionRequest;
import aptech.finalproject.dto.response.product.PromotionOrderStatsResponse;
import aptech.finalproject.dto.response.product.PromotionResponse;

import java.util.List;

public interface PromotionService {
    PromotionResponse createPromotion(PromotionRequest promotionRequest);

    PromotionResponse updatePromotion(Long id, PromotionRequest promotionRequest);

    void deletePromotion(Long id);

    PromotionResponse getPromotionById(Long id);

    List<PromotionResponse> getAllPromotions();

    List<PromotionResponse> getPromotionsByName(String name);

    PromotionOrderStatsResponse getOrderStatsByPromotionId(Long promotionId);
}
