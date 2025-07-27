package aptech.finalproject.dto.request.meal;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealSubCategoryRequest {
    @NotBlank(message = "Subcategory name must not be blank")
    private String subCategoryName;

    @NotNull(message = "Subcategory image must not be null")
    private MultipartFile subCategoryImage;

    @NotBlank(message = "Description must not be blank")
    private String description;

    @NotNull(message = "Category ID must not be null")
    private Integer categoryId;
}