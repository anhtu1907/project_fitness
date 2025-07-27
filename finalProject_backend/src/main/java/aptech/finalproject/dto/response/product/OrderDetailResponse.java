package aptech.finalproject.dto.response.product;


import aptech.finalproject.entity.product.Order;
import aptech.finalproject.entity.product.Product;

import lombok.*;



@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderDetailResponse {
    private Long id;

    private Integer quantity;

    private Double unitPrice;

    private Double subTotal;

    private Long productId;

    private Long orderId;

}
