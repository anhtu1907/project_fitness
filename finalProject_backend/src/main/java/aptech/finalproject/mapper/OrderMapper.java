package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.OrderRequest;
import aptech.finalproject.dto.response.product.OrderResponse;
import aptech.finalproject.entity.product.Order;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper( componentModel = "spring")
public interface OrderMapper {

    @Mapping(target = "user", source = "user.id")
    @Mapping(target = "payment", source = "payment.id")
    OrderResponse toOrderResponse(Order order);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "payment", ignore = true)
    Order toOrder(OrderRequest orderRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "payment", ignore = true)
    void updateOrder(@MappingTarget Order order, OrderRequest orderRequest);
}
