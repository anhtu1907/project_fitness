package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentMethodRequest {

    @NotBlank(message = "Description is required")
    private String description;

    private Long imageId;
}
