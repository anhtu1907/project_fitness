package aptech.finalproject.entity.exercise;

import aptech.finalproject.entity.auth.User;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_favorite")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseFavoriteModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "favorite_id", referencedColumnName = "id")
    @JsonIgnore
    private FavoritesModel favorite;
    @ManyToOne
    @JoinColumn(name = "sub_category_id", referencedColumnName = "id")
    private ExerciseSubCategoryModel subCategory;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;

}
