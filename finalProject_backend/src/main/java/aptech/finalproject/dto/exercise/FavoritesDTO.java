package aptech.finalproject.dto.exercise;


import aptech.finalproject.dto.meal.UserSimpleDTO;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FavoritesDTO {
    private int id;
    private String favoriteName;
    private UserSimpleDTO user;
}
