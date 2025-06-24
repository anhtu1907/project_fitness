package com.example.Project4.models.exercise;

import com.example.Project4.models.auth.UserModel;
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
    private ExerciseSubCategoyrModel subCategory;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private UserModel user;

}
