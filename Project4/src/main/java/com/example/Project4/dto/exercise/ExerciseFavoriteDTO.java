package com.example.Project4.dto.exercise;

import com.example.Project4.dto.meal.UserSimpleDTO;
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
