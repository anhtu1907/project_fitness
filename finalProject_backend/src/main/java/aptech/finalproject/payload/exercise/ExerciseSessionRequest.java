package aptech.finalproject.payload.exercise;

import lombok.*;

@Getter
@Setter
public class ExerciseSessionRequest {
    private int userId;
    private int exerciseId;
    private int subCategoryId;
    private int duration;
    private int resetBatch;
}
