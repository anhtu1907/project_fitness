package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.OrderRequest;
import aptech.finalproject.dto.response.product.OrderResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface OrderService {
    OrderResponse createOrder(OrderRequest orderRequest);

    OrderResponse updateOrder(Long id, OrderRequest orderRequest);

    void deleteOrder(Long id);

    OrderResponse getOrderById(Long id);

    List<OrderResponse> getAllOrders(Pageable pageable);

    List<OrderResponse> getOrdersByUserId(String userId);

}
