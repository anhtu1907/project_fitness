package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExercisesRequest {
    @NotBlank(message = "Exercise name must not be blank")
    private String exerciseName;

    private MultipartFile exerciseImage;

    @NotBlank(message = "Description must not be blank")
    private String description;

    @Positive(message = "Duration must be positive")
    private Integer duration;

    @Positive(message = "Kcal must be positive")
    private Double kcal;

//    @NotNull(message = "Subcategory IDs must not be null")
    private List<Integer> subCategoryIds;

//    @NotNull(message = "Equipment ID must not be null")
    private Integer equipmentId;

//    @NotNull(message = "Mode ID must not be null")
   private Set<Integer> modeIds;
}