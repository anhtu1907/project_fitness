package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.ProductPromotion;
import aptech.finalproject.entity.product.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductPromotionRepository extends JpaRepository<ProductPromotion, Long> {
    void deleteByProductId(Long productId);
    void deleteByPromotionId(Long promotionId);
    List<ProductPromotion> findByPromotion(Promotion promotion);
}
