package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseProgressRequest {
    @NotNull(message = "User ID must not be null")
    private String userId;

    @NotNull(message = "Session ID must not be null")
    private Integer sessionId;

    @PositiveOrZero(message = "Progress must be zero or positive")
    private double progress;
}