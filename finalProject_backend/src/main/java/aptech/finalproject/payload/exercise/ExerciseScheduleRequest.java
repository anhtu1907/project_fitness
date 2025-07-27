package aptech.finalproject.payload.exercise;

import java.time.LocalDateTime;

import lombok.*;

@Getter
@Setter
public class ExerciseScheduleRequest {
    private String user;
    private int subCategory;
    private LocalDateTime scheduleTime;
}
