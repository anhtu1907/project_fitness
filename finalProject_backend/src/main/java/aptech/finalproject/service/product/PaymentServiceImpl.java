package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.PaymentRequest;
import aptech.finalproject.dto.response.product.PaymentResponse;
import aptech.finalproject.entity.product.Order;
import aptech.finalproject.entity.product.Payment;
import aptech.finalproject.entity.product.PaymentMethod;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.PaymentMapper;
import aptech.finalproject.model.CustomUserPrincipal;
import aptech.finalproject.repository.product.OrderRepository;
import aptech.finalproject.repository.product.PaymentMethodRepository;
import aptech.finalproject.repository.product.PaymentRepository;
import aptech.finalproject.security.jwt.AuthenticationFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class PaymentServiceImpl implements PaymentService{
    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private AuthenticationFacade authenticationFacade;

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private PaymentMethodRepository paymentMethodRepository;

    public PaymentResponse createPayment(PaymentRequest paymentRequest) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        Order order = orderRepository.findById(paymentRequest.getOrderId())
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));
        // update status of order
        order.setStatus(true);
        orderRepository.save(order);

        authorizeOwnerOrManager(order, currentUser);

        Payment payment = paymentMapper.toPayment(paymentRequest);
        payment.setOrder(order);

        PaymentMethod paymentMethod = paymentMethodRepository.findById(paymentRequest.getPaymentMethodId())
                .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_METHOD_NOT_FOUND));
        payment.setPaymentMethod(paymentMethod);
        return paymentMapper.toPaymentResponse(paymentRepository.save(payment));
    }


    public PaymentResponse updatePayment(Long id, PaymentRequest paymentRequest) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_NOT_FOUND));

        Order order = orderRepository.findById(paymentRequest.getOrderId())
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));

        authorizeOwnerOrManager(order, currentUser);

        paymentMapper.updatePayment(payment, paymentRequest);

        PaymentMethod paymentMethod = paymentMethodRepository.findById(paymentRequest.getPaymentMethodId())
                .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_METHOD_NOT_FOUND));

        payment.setOrder(order);
        payment.setPaymentMethod(paymentMethod);

        return paymentMapper.toPaymentResponse(paymentRepository.save(payment));
    }


    public void deletePayment(Long id) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_NOT_FOUND));

        requireManagerOrAdmin(currentUser);

        paymentRepository.delete(payment);
    }


    public PaymentResponse getPaymentById(Long id) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_NOT_FOUND));

        authorizeOwnerOrManager(payment.getOrder(), currentUser);

        return paymentMapper.toPaymentResponse(payment);
    }

    public List<PaymentResponse> getAllPayments() {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();
        requireManagerOrAdmin(currentUser);

        return paymentRepository.findAll()
                .stream()
                .map(paymentMapper::toPaymentResponse)
                .collect(Collectors.toList());
    }

    public List<PaymentResponse> getPaymentsByDate(Instant fromDate, Instant toDate) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();
        requireManagerOrAdmin(currentUser);

        return paymentRepository.findByPaymentDateBetween(fromDate, toDate)
                .stream()
                .map(paymentMapper::toPaymentResponse)
                .collect(Collectors.toList());
    }

    public PaymentResponse getPaymentByTransactionCode(String transactionCode) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        Payment payment = paymentRepository.findByTransactionCode(transactionCode);
        if (payment == null) {
            throw new ApiException(ErrorCode.PAYMENT_NOT_FOUND);
        }

        authorizeOwnerOrManager(payment.getOrder(), currentUser);

        return paymentMapper.toPaymentResponse(payment);
    }


    private void requireManagerOrAdmin(CustomUserPrincipal user) {
        if (!isManagerOrAdmin(user)) {
            throw new ApiException(ErrorCode.UNAUTHORIZED);
        }
    }

    private void authorizeOwnerOrManager(Order order, CustomUserPrincipal user) {
        if (!isManagerOrAdmin(user) && !Objects.equals(order.getUser().getId(), user.getId())) {
            throw new ApiException(ErrorCode.UNAUTHORIZED);
        }
    }

    private boolean isManagerOrAdmin(CustomUserPrincipal user) {
        String role = user.getRole();
        return "ROLE_ADMIN".equals(role) || "ROLE_MANAGER".equals(role);
    }

    public void updatePaymentToOrder(Long orderId, Long paymentId){
        Order order = orderRepository.findById(orderId).orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));
        Payment payment = paymentRepository.findById(paymentId) .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_NOT_FOUND));
        order.setPayment(payment);
        orderRepository.save(order);
    }
}
