package aptech.finalproject.service.paypal;

import com.paypal.api.payments.*;
import com.paypal.base.rest.APIContext;
import com.paypal.base.rest.PayPalRESTException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PayPalServiceImpl implements PayPalService {

    @Autowired
    private APIContext apiContext;

    public Payment createPayment(
            Double total,
            String currency,
            String method,
            String intent,
            String description,
            String cancelUrl,
            String successUrl) throws PayPalRESTException {
        System.out.println("Creating payment with total: " + total + ", currency: " + currency + ", method: " + method + ", intent: " + intent);
        System.out.println("Description: " + description);
        System.out.println("Cancel URL: " + cancelUrl);
        System.out.println("Success URL: " + successUrl);
        Amount amount = new Amount();
        amount.setCurrency(currency);
        amount.setTotal(String.format("%.2f", total));

        Transaction transaction = new Transaction();
        transaction.setDescription(description);
        transaction.setAmount(amount);

        List<Transaction> transactions = List.of(transaction);

        Payer payer = new Payer();
        payer.setPaymentMethod(method);

        Payment payment = new Payment();
        payment.setIntent(intent);
        payment.setPayer(payer);
        payment.setTransactions(transactions);

        RedirectUrls redirectUrls = new RedirectUrls();
        redirectUrls.setCancelUrl(cancelUrl);
        redirectUrls.setReturnUrl(successUrl);
        payment.setRedirectUrls(redirectUrls);

        return payment.create(apiContext);
    }

    public Payment executePayment(String paymentId, String payerId) throws PayPalRESTException {
        Payment payment = new Payment();
        payment.setId(paymentId);
        PaymentExecution execution = new PaymentExecution();
        execution.setPayerId(payerId);
        return payment.execute(apiContext, execution);
    }

    public Refund refundSale(String saleId, double amount, String currency) throws PayPalRESTException {
        Sale sale = new Sale();
        sale.setId(saleId);

        Amount refundAmount = new Amount();
        refundAmount.setCurrency(currency);
        refundAmount.setTotal(String.format("%.2f", amount));

        RefundRequest refundRequest = new RefundRequest();
        refundRequest.setAmount(refundAmount);

        return sale.refund(apiContext, refundRequest);
    }
}
