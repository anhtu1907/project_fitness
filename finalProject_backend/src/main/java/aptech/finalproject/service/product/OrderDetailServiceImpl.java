package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.OrderDetailRequest;
import aptech.finalproject.dto.response.product.OrderDetailResponse;
import aptech.finalproject.entity.product.Order;
import aptech.finalproject.entity.product.OrderDetail;
import aptech.finalproject.entity.product.Product;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.OrderDetailMapper;
import aptech.finalproject.model.CustomUserPrincipal;
import aptech.finalproject.repository.product.OrderDetailRepository;
import aptech.finalproject.repository.product.OrderRepository;
import aptech.finalproject.repository.product.ProductRepository;
import aptech.finalproject.security.jwt.AuthenticationFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class OrderDetailServiceImpl implements OrderDetailService{
    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private AuthenticationFacade authenticationFacade;

    public OrderDetailResponse createOrderDetail(OrderDetailRequest orderDetailRequest) {
        OrderDetail orderDetail = orderDetailMapper.toOrderDetail(orderDetailRequest);
        Product product = productRepository.findById(orderDetailRequest.getProductId()).orElseThrow(() -> new ApiException(ErrorCode.PRODUCT_NOT_FOUND));
        Order order = orderRepository.findById(orderDetailRequest.getOrderId()).orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));

        // update stock of product
        int quantity = orderDetailRequest.getQuantity();
        product.setStock(product.getStock() - quantity);
        productRepository.save(product);


        // mapping product and order
        orderDetail.setProduct(product);
        orderDetail.setOrder(order);

        return orderDetailMapper
                .toOrderDetailResponse(orderDetailRepository.save(orderDetail));
    }

    public OrderDetailResponse updateOrderDetail(Long id, OrderDetailRequest request) {
        CustomUserPrincipal currentUser = authenticationFacade.getCurrentUser();

        OrderDetail orderDetail = orderDetailRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_DETAIL_NOT_FOUND));

        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_NOT_FOUND));

        authorizeOwnerOrManager(order.getUser().getId(), currentUser);

        orderDetailMapper.updateOrderDetail(orderDetail, request);

        return orderDetailMapper.toOrderDetailResponse(orderDetailRepository.save(orderDetail));
    }

    @PreAuthorize("hasAuthority('MANAGER_ORDERS')")
    public void deleteOrderDetail(Long id) {
        if (!orderDetailRepository.existsById(id)) {
            throw new ApiException(ErrorCode.ORDER_DETAIL_NOT_FOUND);
        }
        orderDetailRepository.deleteById(id);
    }

    @PreAuthorize("hasAuthority('MANAGER_ORDERS')")
    public List<OrderDetailResponse> getAllOrderDetails(Pageable pageable) {
        return orderDetailRepository.findAll(pageable)
                .stream()
                .map(orderDetailMapper::toOrderDetailResponse)
                .collect(Collectors.toList());
    }

    public OrderDetailResponse getOrderDetailById(Long id) {
        OrderDetail orderDetail = orderDetailRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.ORDER_DETAIL_NOT_FOUND));

        return orderDetailMapper.toOrderDetailResponse(orderDetail);
    }

    public List<OrderDetailResponse> getOrderDetailsByOrderId(Long orderId) {
        List<OrderDetail> orderDetails = orderDetailRepository.findByOrderId(orderId);
        return orderDetails.stream()
                .map(orderDetailMapper::toOrderDetailResponse)
                .collect(Collectors.toList());
    }

    private void requireManagerOrAdmin(CustomUserPrincipal user) {
        if (!isManagerOrAdmin(user)) {
            throw new ApiException(ErrorCode.UNAUTHORIZED);
        }
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

    public Long countOrderDetailsByProductId(Long productId) {
        return orderDetailRepository.countByProductId(productId);
    }
}
