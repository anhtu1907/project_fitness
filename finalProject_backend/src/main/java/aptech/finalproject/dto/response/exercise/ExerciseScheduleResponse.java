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
public class ExerciseScheduleResponse {
    private int id;
    private String userId;
    private int subCategoryId;
    private LocalDateTime scheduleTime;
}