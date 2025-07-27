package aptech.finalproject.dto.response.exercise;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseProgressResponse {
    private int id;
    private String userId;
    private int sessionId;
    private double progress;
    private LocalDateTime lastUpdated;
}
