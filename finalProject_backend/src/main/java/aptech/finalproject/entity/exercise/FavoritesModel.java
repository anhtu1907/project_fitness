package aptech.finalproject.entity.exercise;

import java.util.ArrayList;
import java.util.List;

import aptech.finalproject.entity.auth.User;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="favorites")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FavoritesModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "favorite_name")
    private String favoriteName;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;
    @OneToMany(mappedBy = "favorite", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExerciseFavoriteModel> exerciseFavorites = new ArrayList<>();
}
