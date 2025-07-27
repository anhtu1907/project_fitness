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
public class ExerciseUserResponse {
    private int id;
    private String userId;
    private int sessionId;
    private double kcal;
    private LocalDateTime createdAt;
}
