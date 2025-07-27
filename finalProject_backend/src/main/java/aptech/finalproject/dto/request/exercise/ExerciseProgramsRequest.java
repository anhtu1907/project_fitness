package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseProgramsRequest {
    @NotBlank(message = "Program name must not be blank")
    private String programName;
}