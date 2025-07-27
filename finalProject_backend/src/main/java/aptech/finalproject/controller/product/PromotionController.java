package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.PromotionRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.PromotionOrderStatsResponse;
import aptech.finalproject.dto.response.product.PromotionResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.PromotionService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/promotion")
public class PromotionController {
    @Autowired
    private PromotionService promotionService;

    @PostMapping("/create")
    public ApiResponse<PromotionResponse> create(@RequestBody @Valid PromotionRequest request,
                                                 BindingResult result) {
        System.out.println("Creating promotion with request: " + request);
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        PromotionResponse created = promotionService.createPromotion(request);
        return ApiResponse.created(created, "Created Promotion");
    }


    @GetMapping()
    public ApiResponse<List<PromotionResponse>> getAll() {
        List<PromotionResponse> list = promotionService.getAllPromotions();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PROMOTION_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all Promotions");
    }

    @GetMapping("/{id}")
    public ApiResponse<PromotionResponse> getById(@PathVariable Long id) {
        PromotionResponse response = promotionService.getPromotionById(id);
        return ApiResponse.ok(response, "Get Promotion by ID");
    }

    @GetMapping("/search")
    public ApiResponse<List<PromotionResponse>> getByName(@RequestParam String name) {
        List<PromotionResponse> list = promotionService.getPromotionsByName(name);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PROMOTION_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Search Promotions by name");
    }

    @PutMapping("/{id}")
    public ApiResponse<PromotionResponse> update(@PathVariable Long id,
                                                 @RequestBody @Valid PromotionRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        PromotionResponse updated = promotionService.updatePromotion(id, request);
        return ApiResponse.ok(updated, "Updated Promotion");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        promotionService.deletePromotion(id);
        return ApiResponse.noContent("Deleted Promotion with id: " + id);
    }

    @GetMapping("/{promotionId}/order-stats")
    public ApiResponse<PromotionOrderStatsResponse> getOrderStatsByPromotionId(@PathVariable Long promotionId) {
        PromotionOrderStatsResponse stats = promotionService.getOrderStatsByPromotionId(promotionId);
        return ApiResponse.ok(stats, "Get order stats by promotion id");
    }
}
