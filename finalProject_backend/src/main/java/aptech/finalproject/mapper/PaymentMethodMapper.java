package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.PaymentMethodRequest;
import aptech.finalproject.dto.response.product.PaymentMethodResponse;
import aptech.finalproject.entity.product.PaymentMethod;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper( componentModel = "spring")
public interface PaymentMethodMapper {
    @Mapping(target = "image", source = "image.storedName")
    PaymentMethodResponse toPaymentMethodResponse(PaymentMethod paymentMethod);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "payments", ignore = true)
    PaymentMethod toPaymentMethod(PaymentMethodRequest paymentMethodRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "payments", ignore = true)
    void updatePaymentMethod(@MappingTarget PaymentMethod paymentMethod, PaymentMethodRequest paymentMethodRequest);
}
