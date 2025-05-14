package com.example.Project4.models.exercise;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercise_category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseCategoryModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "category_name")
    private String categoryName;
    @Column(name = "category_image")
    private String categoryImage;
}
