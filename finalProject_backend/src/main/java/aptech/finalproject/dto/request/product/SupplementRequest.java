package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SupplementRequest {

    @NotNull(message = "Size is required")
    @Positive(message = "Size must be greater than 0")
    private Integer size;

    @NotBlank(message = "Ingredient is required")
    private String ingredient;

    @NotNull(message = "Product ID is required")
    private Long productId;

    private List<Long> scategoryIds;
}
