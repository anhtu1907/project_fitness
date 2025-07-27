package aptech.finalproject.dto.request.meal;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserMealsRequest {
    @NotNull(message = "User ID must not be null")
    private String userId;

    @NotNull(message = "Meal ID must not be null")
    private Integer mealId;
}