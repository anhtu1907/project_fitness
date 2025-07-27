package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.PaymentRequest;
import aptech.finalproject.dto.response.product.PaymentResponse;

import java.time.Instant;
import java.util.List;

public interface PaymentService {
    PaymentResponse createPayment(PaymentRequest paymentRequest);

    PaymentResponse updatePayment(Long id, PaymentRequest paymentRequest);

    void deletePayment(Long id);

    PaymentResponse getPaymentById(Long id);

    List<PaymentResponse> getAllPayments();

    List<PaymentResponse> getPaymentsByDate(Instant formDate, Instant toDate);

    PaymentResponse getPaymentByTransactionCode(String transactionCode);

    void updatePaymentToOrder(Long orderId, Long paymentId);
}
