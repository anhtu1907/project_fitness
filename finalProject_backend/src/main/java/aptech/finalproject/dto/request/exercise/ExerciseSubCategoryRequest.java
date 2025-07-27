package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseSubCategoryRequest {
    @NotBlank(message = "Subcategory name must not be blank")
    private String subCategoryName;

    private MultipartFile subCategoryImage;

    @NotBlank(message = "Description must not be blank")
    private String description;

    @NotNull(message = "Category IDs must not be null")
    private Set<@NotNull Integer> categoryIds;
}