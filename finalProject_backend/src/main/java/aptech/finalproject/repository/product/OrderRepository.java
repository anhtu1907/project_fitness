package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    Page<Order> findAll(Pageable pageable);
    List<Order> findByUserId(String userId);

    List<Order> findByOrderDateBetween(Instant orderDateAfter, Instant orderDateBefore);


}
