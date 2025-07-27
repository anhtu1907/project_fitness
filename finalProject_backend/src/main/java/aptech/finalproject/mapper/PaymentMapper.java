package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.PaymentRequest;
import aptech.finalproject.dto.response.product.PaymentResponse;
import aptech.finalproject.entity.product.Payment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper( componentModel = "spring")
public interface PaymentMapper {
    @Mapping(target = "order", source = "order.id")
    @Mapping(target = "paymentMethodName", source = "paymentMethod.description")
    PaymentResponse toPaymentResponse(Payment payment);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "order", ignore = true) // xử lý thủ công trong service
    @Mapping(target = "paymentMethod", ignore = true) // xử lý thủ công trong service
    Payment toPayment(PaymentRequest paymentRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "order", ignore = true)
    @Mapping(target = "paymentMethod", ignore = true)
    void updatePayment(@MappingTarget Payment payment, PaymentRequest paymentRequest);
}
