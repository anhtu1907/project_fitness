package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseModeRequest {
    @NotBlank(message = "Mode name must not be blank")
    private String modeName;
}