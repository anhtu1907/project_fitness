package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.OrderDetailRequest;
import aptech.finalproject.dto.response.product.OrderDetailResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface OrderDetailService {
    OrderDetailResponse createOrderDetail(OrderDetailRequest orderDetailRequest);

    OrderDetailResponse updateOrderDetail(Long id, OrderDetailRequest orderDetailRequest);

    void deleteOrderDetail(Long id);

    List<OrderDetailResponse> getAllOrderDetails(Pageable pageable);

    OrderDetailResponse getOrderDetailById(Long id);

    List<OrderDetailResponse> getOrderDetailsByOrderId(Long orderId);
    Long countOrderDetailsByProductId(Long productId);
}
