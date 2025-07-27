package aptech.finalproject.dto.exercise;

import java.time.LocalDateTime;

import aptech.finalproject.dto.meal.UserSimpleDTO;

import lombok.*;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseProgressDTO {
    private int id;
    private UserSimpleDTO user;
    private ExerciseSessionDTO session;
    private double progress;
    private LocalDateTime lastUpdated;
}
