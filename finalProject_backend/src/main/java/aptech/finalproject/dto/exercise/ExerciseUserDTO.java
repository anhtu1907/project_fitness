package aptech.finalproject.dto.exercise;
import java.time.LocalDateTime;

import aptech.finalproject.dto.meal.UserSimpleDTO;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseUserDTO {
    private int id;
    private UserSimpleDTO user;
    private ExerciseSessionDTO session;
    private double kcal;
    private LocalDateTime createdAt;
}
