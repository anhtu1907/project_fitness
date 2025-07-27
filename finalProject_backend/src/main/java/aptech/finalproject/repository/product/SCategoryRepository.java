package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.SCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SCategoryRepository extends JpaRepository<SCategory, Long> {
}
