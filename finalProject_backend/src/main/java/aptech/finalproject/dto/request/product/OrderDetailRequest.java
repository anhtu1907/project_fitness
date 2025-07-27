package aptech.finalproject.dto.request.product;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderDetailRequest{

    @NotNull(message = "Quantity is required")
    @Positive(message = "Quantity must be greater than 0")
    private Integer quantity;

    @NotNull(message = "Unit price is required")
    @Positive(message = "Unit price must be positive")
    private Double unitPrice;

    @NotNull(message = "Subtotal is required")
    @PositiveOrZero(message = "Subtotal must be zero or more")
    private Double subTotal;

    private Long productId;
    private Long orderId;

}
