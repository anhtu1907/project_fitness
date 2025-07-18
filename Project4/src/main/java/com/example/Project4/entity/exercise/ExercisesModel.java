package com.example.Project4.entity.exercise;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercises")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExercisesModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "exercise_name")
    private String exerciseName;
    @Column(name = "exercise_image")
    private String exerciseImage;
    @Column(name = "description")
    private String description;
    @Column(name = "duration")
    private int duration;
    @Column(name = "total_kcal")
    private double kcal;
    @ManyToMany
    @JoinTable(name = "exercise_subcategories", joinColumns = @JoinColumn(name = "exercise_id"), inverseJoinColumns = @JoinColumn(name = "sub_category_id"))
    private Set<ExerciseSubCategoryModel> subCategory = new HashSet<>();
    @ManyToOne
    @JoinColumn(name = "equipment_id", referencedColumnName = "id")
    private EquipmentsModel equipment;
    @ManyToMany
    @JoinTable(name = "exercise_modes", joinColumns = @JoinColumn(name = "exercise_id"), inverseJoinColumns = @JoinColumn(name = "mode_id"))
    private Set<ExerciseModeModel> modes = new HashSet<>();
}
