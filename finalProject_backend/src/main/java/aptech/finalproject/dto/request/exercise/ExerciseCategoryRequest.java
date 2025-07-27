package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseCategoryRequest {
    @NotBlank(message = "Category name must not be blank")
    private String categoryName;

    private MultipartFile categoryImage;
}