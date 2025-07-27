package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.OrderRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.OrderResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.OrderService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @PostMapping("/create")
    public ApiResponse<OrderResponse> create(@RequestBody @Valid OrderRequest request,
                                             BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        OrderResponse created = orderService.createOrder(request);
        return ApiResponse.created(created, "Created order");
    }

    @GetMapping
    public ApiResponse<List<OrderResponse>> getAll(Pageable pageable) {
        List<OrderResponse> list = orderService.getAllOrders(pageable);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.ORDER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all orders with pagination");
    }

    @GetMapping("/{id}")
    public ApiResponse<OrderResponse> getById(@PathVariable Long id) {
        OrderResponse order = orderService.getOrderById(id);
        return ApiResponse.ok(order, "Get order by ID");
    }

    @PutMapping("/{id}")
    public ApiResponse<OrderResponse> update(@PathVariable Long id,
                                             @RequestBody @Valid OrderRequest request,
                                             BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        OrderResponse updated = orderService.updateOrder(id, request);
        return ApiResponse.ok(updated, "Updated order");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        orderService.deleteOrder(id);
        return ApiResponse.noContent("Deleted order with id: " + id);
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<OrderResponse>> getOrdersByUserId(@PathVariable String userId) {
        List<OrderResponse> orders = orderService.getOrdersByUserId(userId);
        if (orders.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.ORDER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(orders, "Get all orders by userId");
    }
}
