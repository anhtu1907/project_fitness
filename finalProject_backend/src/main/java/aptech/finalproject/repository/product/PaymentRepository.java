package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    List<Payment> findByPaymentDateBetween(Instant paymentDateAfter, Instant paymentDateBefore);

    boolean existsByTransactionCode(String transactionCode);

    Payment findByTransactionCode(String transactionCode);
}
