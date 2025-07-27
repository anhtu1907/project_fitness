package aptech.finalproject.dto.response.exercise;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseFavoriteResponse {
    private int id;
    private int favoriteId;
    private int subCategoryId;
    private String userId;
}
