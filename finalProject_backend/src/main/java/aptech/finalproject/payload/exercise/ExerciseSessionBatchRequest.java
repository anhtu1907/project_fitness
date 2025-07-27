package aptech.finalproject.payload.exercise;

import java.util.List;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSessionBatchRequest {
    private List<ExerciseSessionRequest> sessions;
    private String userId;
    private Integer resetBatch;
    private Integer subCategoryId;
}