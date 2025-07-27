package aptech.finalproject.dto.response.product;


import aptech.finalproject.dto.product.ProductWithPromotionDTO;
import lombok.*;

import java.time.Instant;
import java.util.Set;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PromotionResponse {
    private Long id;

    private String name;

    private Float discount;

    private Instant startDate;

    private Instant endDate;

    private Set<ProductWithPromotionDTO> products;

    private Integer usageLimit;
}
