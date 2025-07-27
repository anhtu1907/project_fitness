package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.PaymentMethodRequest;
import aptech.finalproject.dto.response.product.PaymentMethodResponse;

import java.util.List;

public interface PaymentMethodService {
    PaymentMethodResponse createPaymentMethod(PaymentMethodRequest paymentMethodRequest);

    PaymentMethodResponse updatePaymentMethod(Long id, PaymentMethodRequest paymentMethodRequest);

    void deletePaymentMethod(Long id);

    List<PaymentMethodResponse> getAllPaymentMethods();

    PaymentMethodResponse getPaymentMethodById(Long id);
}
