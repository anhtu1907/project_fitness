package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.OrderRequest;
import aptech.finalproject.dto.response.product.OrderResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.product.Order;
import aptech.finalproject.entity.product.Payment;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.OrderMapper;
import aptech.finalproject.model.CustomUserPrincipal;
import aptech.finalproject.repository.UserRepository;
import aptech.finalproject.repository.product.OrderRepository;
import aptech.finalproject.repository.product.PaymentRepository;
import aptech.finalproject.security.jwt.AuthenticationFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl implements OrderService{
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private AuthenticationFacade authFacade;

    @Autowired
    private AuthenticationFacade authenticationFacade;

    public OrderResponse createOrder(OrderRequest orderRequest) {
        Order order = orderMapper.toOrder(orderRequest);

        User user = userRepository.findById(authFacade.getCurrentUser().getId())
                .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
        order.setUser(user);

//        Payment payment = paymentRepository.findById(orderRequest.getPaymentId())
//                .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_NOT_FOUND));
//        order.setPayment(payment);
        order.setOrderDate(Instant.now());
        order.setDelivered(false);
        order.setStatus(false);
        return orderMapper.toOrderResponse(orderRepository.save(order));
    }

    @Transactional
    public OrderResponse updateOrder(Long id, OrderRequest orderRequest) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));


        if (orderRequest.getPaymentId() != null) {
            Payment payment = paymentRepository.findById(orderRequest.getPaymentId())
                    .orElseThrow(() -> new ApiException(ErrorCode.PAYMENT_NOT_FOUND));
            order.setPayment(payment);
        }

        orderMapper.updateOrder(order, orderRequest);

        return orderMapper.toOrderResponse(orderRepository.save(order));
    }
    @PreAuthorize("hasAuthority('MANAGE_ORDERS')")
    public void deleteOrder(Long id) {
        if (!orderRepository.existsById(id)) {
            throw new ApiException(ErrorCode.ORDER_NOT_FOUND);
        }
        orderRepository.deleteById(id);
    }

    public OrderResponse getOrderById(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));
        return orderMapper.toOrderResponse(order);
    }

    @PreAuthorize("hasAuthority('MANAGE_ORDERS')")
    public List<OrderResponse> getAllOrders(Pageable pageable) {
        return orderRepository.findAll(pageable)
                .stream()
                .map(orderMapper::toOrderResponse)
                .collect(Collectors.toList());
    }

    private void authorizeOwnerOrManager(String userId, CustomUserPrincipal currentUser) {
        if (!isManagerOrAdmin(currentUser) && !Objects.equals(userId, currentUser.getId())) {
            throw new ApiException(ErrorCode.UNAUTHORIZED);
        }
    }

    private boolean isManagerOrAdmin(CustomUserPrincipal user) {
        String role = user.getRole();
        return "ADMIN".equals(role) || "MANAGER".equals(role);
    }

    @PreAuthorize("hasAuthority('MANAGE_ORDERS') or #userId == authentication.principal.id")
    public List<OrderResponse> getOrdersByUserId(String userId) {
        List<Order> orders = orderRepository.findByUserId(userId);
        return orders.stream()
                .map(orderMapper::toOrderResponse)
                .collect(Collectors.toList());
    }


}
