package aptech.finalproject.dto.product;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
public class ProductPromotionDTO {
    private Long promotionId;
    private String promotionName;
    private Float discountOverride;
    private Instant startDate;
    private Instant endDate;
}