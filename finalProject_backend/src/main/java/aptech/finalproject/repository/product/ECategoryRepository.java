package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.ECategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ECategoryRepository extends JpaRepository<ECategory, Long> {

}
