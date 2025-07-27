package aptech.finalproject.service.paypal;

import com.paypal.api.payments.Payment;
import com.paypal.api.payments.Refund;
import com.paypal.base.rest.PayPalRESTException;

public interface PayPalService {
     Payment createPayment(
            Double total,
            String currency,
            String method,
            String intent,
            String description,
            String cancelUrl,
            String successUrl) throws PayPalRESTException ;
    Payment executePayment(String paymentId, String payerId) throws PayPalRESTException;

    Refund refundSale(String saleId, double amount, String currency) throws PayPalRESTException;
}
