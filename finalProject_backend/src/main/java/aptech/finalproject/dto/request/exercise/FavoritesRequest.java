package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class FavoritesRequest {
    @NotBlank(message = "Favorite name must not be blank")
    private String favoriteName;

    @NotNull(message = "User ID must not be null")
    private String userId;
}