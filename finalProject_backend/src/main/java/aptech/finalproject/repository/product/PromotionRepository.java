package aptech.finalproject.repository.product;

import aptech.finalproject.dto.response.product.PromotionResponse;
import aptech.finalproject.entity.product.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Long> {
    List<Promotion> findByNameLike(String name);
}
