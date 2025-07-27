package aptech.finalproject.dto.response.exercise;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class FavoritesResponse {
    private int id;
    private String favoriteName;
    private String userId;
    private List<Integer> exerciseFavoriteIds;
}
