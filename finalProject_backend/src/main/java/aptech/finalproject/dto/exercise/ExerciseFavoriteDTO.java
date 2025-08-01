package aptech.finalproject.dto.exercise;

import aptech.finalproject.dto.meal.UserSimpleDTO;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseFavoriteDTO {
    private int id;
    private UserSimpleDTO user;
    private FavoritesDTO favorite;
    private ExerciseSubCategoryDTO subCategory;
}
