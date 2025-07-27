package aptech.finalproject.payload.exercise;

import java.time.LocalDateTime;

import lombok.*;

@Getter
@Setter
public class ExerciseProgressRequest {
    private int user;
    private int exercises;
    private LocalDateTime lastUpdated;
}
