package com.example.Project4.models.exercise;

import java.util.ArrayList;
import java.util.List;

import com.example.Project4.models.auth.UserModel;

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
    private UserModel user;
    @OneToMany(mappedBy = "favorite", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExerciseFavoriteModel> exerciseFavorites = new ArrayList<>();
}
