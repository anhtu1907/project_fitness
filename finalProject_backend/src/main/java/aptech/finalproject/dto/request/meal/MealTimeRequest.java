package aptech.finalproject.dto.request.meal;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealTimeRequest {
    @NotBlank(message = "Time name must not be blank")
    private String timeName;
}