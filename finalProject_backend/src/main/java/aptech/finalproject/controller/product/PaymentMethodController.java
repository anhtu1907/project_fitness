package aptech.finalproject.controller.product;

import aptech.finalproject.dto.request.product.PaymentMethodRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.product.PaymentMethodResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.product.PaymentMethodService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payment-method")
public class PaymentMethodController {
    @Autowired
    private PaymentMethodService paymentMethodService;

    @PostMapping("/create")
    public ApiResponse<PaymentMethodResponse> create(@RequestBody @Valid PaymentMethodRequest request,
                                                     BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        PaymentMethodResponse created = paymentMethodService.createPaymentMethod(request);
        return ApiResponse.created(created, "Created Payment Method");
    }

    @GetMapping
    public ApiResponse<List<PaymentMethodResponse>> getAll() {
        List<PaymentMethodResponse> list = paymentMethodService.getAllPaymentMethods();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.PAYMENT_METHOD_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all Payment Methods");
    }

    @GetMapping("/{id}")
    public ApiResponse<PaymentMethodResponse> getById(@PathVariable Long id) {
        PaymentMethodResponse response = paymentMethodService.getPaymentMethodById(id);
        return ApiResponse.ok(response, "Get Payment Method by ID");
    }

    @PutMapping("/{id}")
    public ApiResponse<PaymentMethodResponse> update(@PathVariable Long id,
                                                     @RequestBody @Valid PaymentMethodRequest request,
                                                     BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        PaymentMethodResponse updated = paymentMethodService.updatePaymentMethod(id, request);
        return ApiResponse.ok(updated, "Updated Payment Method");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        paymentMethodService.deletePaymentMethod(id);
        return ApiResponse.noContent("Deleted Payment Method with id: " + id);
    }
}
