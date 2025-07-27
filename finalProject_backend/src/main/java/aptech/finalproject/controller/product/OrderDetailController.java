package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.OrderDetailRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.OrderDetailResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.OrderDetailService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order-detail")
public class OrderDetailController {
    @Autowired
    private OrderDetailService orderDetailService;

    @PostMapping("/create")
    public ApiResponse<OrderDetailResponse> create(@RequestBody @Valid OrderDetailRequest request,
                                                   BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        OrderDetailResponse created = orderDetailService.createOrderDetail(request);
        return ApiResponse.created(created, "Created order detail");
    }

    @PutMapping("/{id}")
    public ApiResponse<OrderDetailResponse> update(@PathVariable Long id,
                                                   @RequestBody @Valid OrderDetailRequest request,
                                                   BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        OrderDetailResponse updated = orderDetailService.updateOrderDetail(id, request);
        return ApiResponse.ok(updated, "Updated order detail");
    }

    @GetMapping
    public ApiResponse<List<OrderDetailResponse>> getAll(Pageable pageable) {
        List<OrderDetailResponse> list = orderDetailService.getAllOrderDetails(pageable);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.ORDER_DETAIL_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all order details");
    }


    @GetMapping("/order/{orderId}")
    public ApiResponse<List<OrderDetailResponse>> getByOrderId(@PathVariable Long orderId) {
        List<OrderDetailResponse> list = orderDetailService.getOrderDetailsByOrderId(orderId);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.ORDER_DETAIL_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get order details by order id");
    }

    @GetMapping("/{id}")
    public ApiResponse<OrderDetailResponse> getById(@PathVariable Long id) {
        OrderDetailResponse response = orderDetailService.getOrderDetailById(id);
        return ApiResponse.ok(response, "Get order detail by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        orderDetailService.deleteOrderDetail(id);
        return ApiResponse.noContent("Deleted order detail with id " + id);
    }

    @GetMapping("/count-by-product/{productId}")
    public ApiResponse<Long> countOrderDetailsByProduct(@PathVariable Long productId) {
        long count = orderDetailService.countOrderDetailsByProductId(productId);
        return ApiResponse.ok(count, "Count of orders for product " + productId);
    }
}
