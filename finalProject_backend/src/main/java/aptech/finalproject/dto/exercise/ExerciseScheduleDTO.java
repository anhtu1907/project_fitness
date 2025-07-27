package aptech.finalproject.dto.exercise;

import java.time.LocalDateTime;

import aptech.finalproject.dto.meal.UserSimpleDTO;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseScheduleDTO {
    private int id;
    private UserSimpleDTO user;
    private ExerciseSubCategoryDTO subCategory;
    private LocalDateTime scheduleTime;
}
