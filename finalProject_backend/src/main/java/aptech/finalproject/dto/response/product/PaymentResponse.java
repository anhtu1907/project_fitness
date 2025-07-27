package aptech.finalproject.dto.response.product;

import lombok.*;

import java.time.Instant;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentResponse {
    private Long id;

    private String transactionCode;

    private Instant paymentDate;

    private Integer amount;

    private String currency;

    private Boolean status;

    private Long order;

    private String paymentMethodName;
}
