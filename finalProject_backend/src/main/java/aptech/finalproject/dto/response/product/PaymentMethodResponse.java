package aptech.finalproject.dto.response.product;


import lombok.*;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentMethodResponse {
    private Long id;

    private String description;

    private String image;

}
