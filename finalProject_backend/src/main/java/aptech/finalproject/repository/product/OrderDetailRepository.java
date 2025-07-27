package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.OrderDetail;
import aptech.finalproject.entity.product.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long> {
    Page<OrderDetail> findAll(Pageable pageable);
    List<OrderDetail> findByOrderId(Long orderId);

    List<OrderDetail> findByProductIn(Set<Product> products);

    Long countByProductId(Long productId);
}
