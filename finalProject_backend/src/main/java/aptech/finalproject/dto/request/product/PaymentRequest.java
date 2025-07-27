package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.time.Instant;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentRequest {

    @NotBlank(message = "Transaction code is required")
    private String transactionCode;

    @NotNull(message = "Payment date is required")
    private Instant paymentDate;

    @NotNull(message = "Amount is required")
    @Positive(message = "Amount must be greater than 0")
    private Integer amount;

    @NotNull(message = "Status is required")
    private Boolean status;


    @NotNull(message = "Currency is required")
    private String currency;

    @NotNull(message = "Order ID is required")
    private Long orderId;

    @NotNull(message = "Payment method ID is required")
    private Long paymentMethodId;
}
