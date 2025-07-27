package aptech.finalproject.dto.exercise;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSubCategoryProgramDTO {
    private int id;
    private ExerciseSubCategoryDTO subCategory;
    private ExerciseProgramsDTO program;
}
