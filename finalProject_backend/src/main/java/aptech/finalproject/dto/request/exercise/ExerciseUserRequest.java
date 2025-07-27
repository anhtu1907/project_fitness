package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseUserRequest {
    @NotNull(message = "User ID must not be null")
    private String userId;

    @NotNull(message = "Session ID must not be null")
    private Integer sessionId;

    @PositiveOrZero(message = "Kcal must be zero or positive")
    private double kcal;

    @NotNull(message = "Created at must not be null")
    private LocalDateTime createdAt;
}