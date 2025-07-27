package aptech.finalproject.dto.response.product;


import lombok.*;

import java.time.Instant;
import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderResponse {
    private Long id;

    private Instant orderDate;

    private Integer totalAmount;

    private Boolean status;

    private Boolean delivered;

    private String user;

    private Long payment;

}
