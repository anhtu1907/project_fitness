package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseScheduleRequest {
    @NotNull(message = "User ID must not be null")
    private String userId;

    @NotNull(message = "Subcategory ID must not be null")
    private Integer subCategoryId;

    @NotNull(message = "Schedule time must not be null")
    private LocalDateTime scheduleTime;
}