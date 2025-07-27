package aptech.finalproject.dto.request.product;


import aptech.finalproject.validation.ValidPromotionDates;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.Instant;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ValidPromotionDates
public class PromotionRequest {

    @NotBlank(message = "Promotion name is required")
    @Size(min = 4, message = "Promotion name must be longer than 3 characters")
    private String name;

    @NotNull(message = "Discount is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Discount must be greater than 0")
    @DecimalMax(value = "0.5", inclusive = false, message = "Discount must be less than 0.5")
    private Float discount;

    @NotNull(message = "Start date is required")
    private Instant startDate;

    @NotNull(message = "End date is required")
    private Instant endDate;

    @NotNull(message = "Product list must not be null")
    @Size(min = 1, message = "At least one product must be selected")
    private Set<Long> productIds;
    @Min(value = 1, message = "Usage limit must be at least 1")
    @Max(value = 999, message = "Usage limit must be at most 999")
    private Integer usageLimit;
}
