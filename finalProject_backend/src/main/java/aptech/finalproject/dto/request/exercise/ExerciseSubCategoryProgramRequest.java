package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseSubCategoryProgramRequest {
    @NotNull(message = "Subcategory ID must not be null")
    private Integer subCategoryId;

    @NotNull(message = "Program ID must not be null")
    private Integer programId;
}