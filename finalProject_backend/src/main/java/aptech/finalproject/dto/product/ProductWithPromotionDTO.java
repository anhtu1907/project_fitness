package aptech.finalproject.dto.product;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
public class ProductWithPromotionDTO {
    private Long productId;
    private String productName;
    private Double price;

    private Float discountOverride;
    private Instant startDate;
    private Instant endDate;
}
