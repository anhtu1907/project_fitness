package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.PromotionRequest;
import aptech.finalproject.dto.response.product.PromotionOrderStatsResponse;
import aptech.finalproject.dto.response.product.PromotionResponse;
import aptech.finalproject.entity.product.*;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.PromotionMapper;
import aptech.finalproject.repository.product.OrderDetailRepository;
import aptech.finalproject.repository.product.ProductPromotionRepository;
import aptech.finalproject.repository.product.ProductRepository;
import aptech.finalproject.repository.product.PromotionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class PromotionServiceImpl implements PromotionService {

    @Autowired private PromotionRepository promotionRepository;
    @Autowired private PromotionMapper promotionMapper;
    @Autowired private ProductRepository productRepository;
    @Autowired private OrderDetailRepository orderDetailRepository;
    @Autowired private ProductPromotionRepository productPromotionRepository;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public PromotionResponse createPromotion(PromotionRequest request) {
        validatePromotionDates(request);



        Promotion promotion = promotionMapper.toPromotion(request);
        promotion = promotionRepository.save(promotion);

        if (request.getProductIds() != null && !request.getProductIds().isEmpty()) {
            List<Product> products = productRepository.findAllById(request.getProductIds());

            for (Product product : products) {
                ProductPromotion pp = ProductPromotion.builder()
                        .product(product)
                        .promotion(promotion)
                        .startDate(request.getStartDate())
                        .endDate(request.getEndDate())
                        .discountOverride(promotion.getDiscount())
                        .build();
                productPromotionRepository.save(pp);
            }
        }

        return promotionMapper.toPromotionResponse(promotion);
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    @Transactional
    public PromotionResponse updatePromotion(Long id, PromotionRequest request) {
        validatePromotionDates(request);

        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.PROMOTION_NOT_FOUND));

        promotionMapper.updatePromotion(promotion, request);
        Promotion savedPromotion = promotionRepository.save(promotion);

        List<ProductPromotion> existingLinks = productPromotionRepository.findByPromotion(savedPromotion);
        Set<Long> newProductIds = request.getProductIds();
        List<ProductPromotion> toRemove = existingLinks.stream()
                .filter(link -> !newProductIds.contains(link.getProduct().getId()))
                .toList();
        productPromotionRepository.deleteAll(toRemove);


        productPromotionRepository.deleteByPromotionId(promotion.getId());

        if (request.getProductIds() != null && !request.getProductIds().isEmpty()) {
            List<ProductPromotion> links = request.getProductIds().stream()
                    .map(data -> {
                        Product product = productRepository.findById(data)
                                .orElseThrow(() -> new ApiException(ErrorCode.PRODUCT_NOT_FOUND));
                        return ProductPromotion.builder()
                                .product(product)
                                .promotion(savedPromotion)
                                .startDate(request.getStartDate())
                                .endDate(request.getEndDate())
                                .discountOverride(request.getDiscount())
                                .build();
                    }).toList();

            productPromotionRepository.saveAll(links);
        }

        return promotionMapper.toPromotionResponse(promotion);
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    @Transactional
    public void deletePromotion(Long id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.PROMOTION_NOT_FOUND));

        productPromotionRepository.deleteByPromotionId(id);
        promotionRepository.delete(promotion);
    }

    public PromotionResponse getPromotionById(Long id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.PROMOTION_NOT_FOUND));
        return promotionMapper.toPromotionResponse(promotion);
    }

    public List<PromotionResponse> getAllPromotions() {
        return promotionRepository.findAll()
                .stream()
                .map(promotionMapper::toPromotionResponse)
                .collect(Collectors.toList());
    }

    public List<PromotionResponse> getPromotionsByName(String name) {
        return promotionRepository.findByNameLike(name)
                .stream()
                .map(promotionMapper::toPromotionResponse)
                .collect(Collectors.toList());
    }

    public PromotionOrderStatsResponse getOrderStatsByPromotionId(Long promotionId) {
        Promotion promotion = promotionRepository.findById(promotionId)
                .orElseThrow(() -> new ApiException(ErrorCode.PROMOTION_NOT_FOUND));

        List<ProductPromotion> links = productPromotionRepository.findByPromotion(promotion);
        List<Product> products = links.stream().map(ProductPromotion::getProduct).toList();

        List<OrderDetail> orderDetails = orderDetailRepository.findByProductIn(new HashSet<>(products));
        Set<Order> uniqueOrders = orderDetails.stream()
                .map(OrderDetail::getOrder)
                .collect(Collectors.toSet());

        long orderCount = uniqueOrders.size();
        long orderDetailCount = orderDetails.size();
        long paid = uniqueOrders.stream().filter(Order::getStatus).count();
        long unpaid = uniqueOrders.size() - paid;

        return new PromotionOrderStatsResponse(orderCount, orderDetailCount, paid, unpaid);
    }

    private void validatePromotionDates(PromotionRequest req) {
        Instant now = Instant.now();
        if (req.getStartDate() == null || req.getEndDate() == null
                || !req.getStartDate().isAfter(now)
                || !req.getEndDate().isAfter(req.getStartDate())) {
            throw new ApiException(ErrorCode.DATE_VALUE_INVALID);
        }
    }
}
