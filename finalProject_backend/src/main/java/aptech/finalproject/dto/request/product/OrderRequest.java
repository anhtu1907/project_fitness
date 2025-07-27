package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderRequest {

    @NotNull(message = "Order date is required")
    private Instant orderDate;

    @NotNull(message = "Total amount is required")
    @Positive(message = "Total amount must be positive")
    private BigDecimal totalAmount;

    private Boolean status;

    private Boolean delivered;

    // private String userId;

    private Long paymentId;
}
