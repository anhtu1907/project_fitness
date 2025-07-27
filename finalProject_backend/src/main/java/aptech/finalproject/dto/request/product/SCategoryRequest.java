package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SCategoryRequest {
    @NotBlank(message = "Category name is required")
    private String name;

    private String description;

    private List<Long> supplementIds;
}
