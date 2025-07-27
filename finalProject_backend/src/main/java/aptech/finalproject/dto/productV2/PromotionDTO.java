package aptech.finalproject.dto.productV2;

import lombok.Builder;
import lombok.Data;

import java.time.Instant;
@Data
@Builder
public class PromotionDTO {
    private Long promotionId;
    private String promotionName;
    private Float discountOverride;
    private Instant startDate;
    private Instant endDate;
}
