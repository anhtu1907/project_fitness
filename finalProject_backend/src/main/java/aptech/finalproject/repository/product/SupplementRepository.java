package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.Supplement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SupplementRepository extends JpaRepository<Supplement, Long> {
}
