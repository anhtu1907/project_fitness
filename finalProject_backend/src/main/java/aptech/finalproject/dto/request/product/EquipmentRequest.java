package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EquipmentRequest {

    @NotNull(message = "Size is required")
    private Integer size;

    @NotBlank(message = "Color is required")
    @Size(max = 30, message = "Color must not exceed 30 characters")
    private String color;

    @NotBlank(message = "Gender is required")
    private String gender;

    private List<Long> categoryIds;

    @NotNull(message = "Product ID is required")
    private Long productId;
}
