package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.OrderRequest;
import aptech.finalproject.dto.request.product.PaymentRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.PaymentResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.product.Order;
import aptech.finalproject.entity.product.PaymentMethod;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.model.CustomUserPrincipal;
import aptech.finalproject.repository.UserRepository;
import aptech.finalproject.repository.product.OrderRepository;
import aptech.finalproject.repository.product.PaymentMethodRepository;
import aptech.finalproject.repository.product.PaymentRepository;
import aptech.finalproject.service.paypal.PayPalService;
import aptech.finalproject.service.product.PaymentService;

import aptech.finalproject.entity.product.Payment;
import com.paypal.base.rest.PayPalRESTException;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.Instant;
import java.util.List;
import java.util.Map;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;
    private final PayPalService payPalService;
    private final PaymentRepository paymentRepository;
    private final OrderRepository orderRepository;
    private final PaymentMethodRepository paymentMethodRepository;
    private final UserRepository userRepository;

    @Value("${paypal.successUrl}")
    private String successUrl;

    @Value("${paypal.cancelUrl}")
    private String cancelUrl;

    @PostMapping("/create")
    public ApiResponse<PaymentResponse> create(@RequestBody @Valid PaymentRequest request,
            BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        PaymentResponse created = paymentService.createPayment(request);
        // why not update paymentId to order ?
        paymentService.updatePaymentToOrder(request.getOrderId(), created.getId());
        return ApiResponse.created(created, "Created Payment");
    }

    @GetMapping()
    public ApiResponse<List<PaymentResponse>> getAll() {
        List<PaymentResponse> list = paymentService.getAllPayments();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PAYMENT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all Payments");
    }

    @GetMapping("/{id}")
    public ApiResponse<PaymentResponse> getById(@PathVariable Long id) {
        PaymentResponse response = paymentService.getPaymentById(id);
        return ApiResponse.ok(response, "Get Payment by ID");
    }

    @GetMapping("/transaction")
    public ApiResponse<PaymentResponse> getByTransactionCode(@RequestParam String code) {
        PaymentResponse response = paymentService.getPaymentByTransactionCode(code);
        return ApiResponse.ok(response, "Get Payment by Transaction Code");
    }

    @GetMapping("/filter")
    public ApiResponse<List<PaymentResponse>> getByDate(@RequestParam Instant from,
            @RequestParam Instant to) {
        List<PaymentResponse> list = paymentService.getPaymentsByDate(from, to);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PAYMENT_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get Payments by Date Range");
    }

    @PutMapping("/{id}")
    public ApiResponse<PaymentResponse> update(@PathVariable Long id,
            @RequestBody @Valid PaymentRequest request,
            BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        PaymentResponse updated = paymentService.updatePayment(id, request);
        return ApiResponse.ok(updated, "Updated Payment");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        paymentService.deletePayment(id);
        return ApiResponse.noContent("Deleted Payment with id: " + id);
    }

    @PostMapping("/paypal")
    public ResponseEntity<?> paymentWithPayPal(@RequestParam Double amount, @RequestParam Long orderId) {
        try {
            com.paypal.api.payments.Payment payment = payPalService.createPayment(
                    amount,
                    "USD",
                    "paypal",
                    "sale",
                    "Payment for order",
                    cancelUrl,
                    successUrl + "?orderId=" + orderId);

            for (com.paypal.api.payments.Links link : payment.getLinks()) {
                if (link.getRel().equals("approval_url")) {
                    return ResponseEntity.ok(Map.of("redirectUrl", link.getHref()));
                }
            }
        } catch (PayPalRESTException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Unable to create PayPal payment");
    }

    @GetMapping("/paypal/success")
    public void paypalSuccessRedirect(
            @RequestParam("paymentId") String paymentId,
            @RequestParam("PayerID") String payerID,
            @RequestParam(value = "orderId", required = false) Long orderId,
            HttpServletResponse response) throws IOException {
        String redirectUrl = "http://localhost:3000/payment/success?paymentId=" + paymentId
                + "&payerID=" + payerID;
        if (orderId != null) {
            redirectUrl += "&orderId=" + orderId;
        }
        response.sendRedirect(redirectUrl);
    }

    @PostMapping("/paypal/execute")
    public ResponseEntity<?> executePaypalPayment(
            @RequestParam("paymentId") String paymentId,
            @RequestParam("payerID") String payerId,
            @RequestParam("orderId") Long orderId) {
        try {
            com.paypal.api.payments.Payment executedPayment = payPalService.executePayment(paymentId, payerId);
            System.out.println("💳 Executed Payment: " + executedPayment);
            if ("approved".equalsIgnoreCase(executedPayment.getState())) {

                List<com.paypal.api.payments.Transaction> transactions = executedPayment.getTransactions();
                if (transactions == null || transactions.isEmpty()) {
                    return ResponseEntity.status(400).body("Không có transaction nào.");
                }

                com.paypal.api.payments.Transaction transaction = transactions.get(0);
                List<com.paypal.api.payments.RelatedResources> relatedResources = transaction.getRelatedResources();
                if (relatedResources == null || relatedResources.isEmpty()) {
                    return ResponseEntity.status(400).body("Không có related resource nào.");
                }

                com.paypal.api.payments.Sale sale = relatedResources.get(0).getSale();
                if (sale == null) {
                    return ResponseEntity.status(400).body("Không có sale trong related resource.");
                }

                String saleId = sale.getId();
                String currency = sale.getAmount().getCurrency();
                double total = Double.parseDouble(sale.getAmount().getTotal());

                Order order = orderRepository.findById(orderId)
                        .orElseThrow(() -> new RuntimeException("Order không tồn tại"));

                PaymentMethod method = paymentMethodRepository.findByNameIgnoreCase("paypal")
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy phương thức 'paypal'"));

                Payment paymentEntity = Payment.builder()
                        .transactionCode(saleId)
                        .paymentDate(Instant.now())
                        .amount((int) (total * 100)) // Convert về cent
                        .status(true)
                        .currency(currency)
                        .order(order)
                        .paymentMethod(method)
                        .build();

                paymentRepository.save(paymentEntity);
                return ResponseEntity.ok("Thanh toán PayPal thành công và đã lưu vào database.");
            }

            return ResponseEntity.status(400).body("Thanh toán không được phê duyệt.");
        } catch (PayPalRESTException e) {
            return ResponseEntity.status(500).body("Lỗi xử lý thanh toán: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(400).body("❗ " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi hệ thống: " + e.getMessage());
        }
    }

    @PostMapping("/refund")
    public ResponseEntity<?> refund(@RequestParam String saleId, @RequestParam double amount) {
        try {
            com.paypal.api.payments.Refund refund = payPalService.refundSale(saleId, amount, "USD");
            return ResponseEntity.ok(refund);
        } catch (PayPalRESTException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getDetails());
        }
    }

    @GetMapping("/paypal/cancel")
    public String cancel() {
        return "Payment canceled.";
    }

   @PostMapping("/order")
   public ResponseEntity<?> createOrder(@RequestBody @Valid OrderRequest request,
           @AuthenticationPrincipal CustomUserPrincipal userPrincipal) {

       User user = userRepository.findById(userPrincipal.getId())
               .orElseThrow(() -> new RuntimeException("User not found"));

       Order order = new Order();
       order.setOrderDate(request.getOrderDate() != null ? request.getOrderDate() : Instant.now());
       order.setStatus(request.getStatus() != null ? request.getStatus() : false);
       order.setDelivered(request.getDelivered() != null ? request.getDelivered() : false);
       order.setTotalAmount(request.getTotalAmount());
       order.setUser(user);

       orderRepository.save(order);

       return ResponseEntity.ok(Map.of("orderId", order.getId()));
   }

}
