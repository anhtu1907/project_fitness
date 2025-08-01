package aptech.finalproject.dto.exercise;
import java.time.LocalDateTime;

import aptech.finalproject.dto.meal.UserSimpleDTO;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSessionDTO {
   private int id;
    private UserSimpleDTO user;
    private ExercisesDTO exercise;
    private ExerciseSubCategoryDTO subCategory;
    private double kcal;
    private int resetBatch;
    private int duration;
    private LocalDateTime createdAt;
}
