package aptech.finalproject.dto.request.meal;

import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealCategoryRequest {

    private MultipartFile categoryImage;

    @NotBlank(message = "Category name must not be blank")
    private String categoryName;
}