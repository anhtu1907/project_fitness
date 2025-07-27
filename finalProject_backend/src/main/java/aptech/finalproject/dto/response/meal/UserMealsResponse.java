package aptech.finalproject.dto.response.meal;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserMealsResponse {
    private int id;
    private int userId;
    private int mealId;
    private LocalDateTime createdAt;
}