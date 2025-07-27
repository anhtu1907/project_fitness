package aptech.finalproject.dto.response.exercise;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseSessionResponse {
    private int id;
    private String userId;
    private int exerciseId;
    private int subCategoryId;
    private double kcal;
    private int resetBatch;
    private int duration;
    private LocalDateTime createdAt;
}
