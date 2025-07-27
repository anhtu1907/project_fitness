package aptech.finalproject.dto.request.product;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class CategoryRequest {
    @NotBlank( message = "Name must not be blank")
    @Size(max = 100, message = "Name must not exceed 100 characters")
    private String name;

    private String description;
}
