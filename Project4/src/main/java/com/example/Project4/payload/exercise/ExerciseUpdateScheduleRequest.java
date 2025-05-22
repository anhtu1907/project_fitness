package com.example.Project4.payload.exercise;

import java.time.LocalDateTime;
import lombok.*;

@Getter
@Setter
public class ExerciseUpdateScheduleRequest {
    private int scheduleId;
    private LocalDateTime scheduleTime;
}
