package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseFavoriteRequest {
    @NotNull(message = "Favorite ID must not be null")
    private Integer favoriteId;

    @NotNull(message = "Subcategory ID must not be null")
    private Integer subCategoryId;

    @NotNull(message = "User ID must not be null")
    private String userId;
}