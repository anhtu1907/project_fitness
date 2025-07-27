package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseSessionRequest {
    @NotNull(message = "User ID must not be null")
    private String userId;

    @NotNull(message = "Exercise ID must not be null")
    private Integer exerciseId;

    @NotNull(message = "Subcategory ID must not be null")
    private Integer subCategoryId;

    @PositiveOrZero(message = "Kcal must be zero or positive")
    private double kcal;

    @PositiveOrZero(message = "Reset batch must be zero or positive")
    private int resetBatch;

    @PositiveOrZero(message = "Duration must be zero or positive")
    private int duration;

    @NotNull(message = "Created at must not be null")
    private LocalDateTime createdAt;
}