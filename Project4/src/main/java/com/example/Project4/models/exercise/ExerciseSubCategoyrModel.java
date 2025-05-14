package com.example.Project4.models.exercise;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_sub_category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSubCategoyrModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "sub_category_name")
    private String subCategoryName;
    @Column(name = "sub_category_image")
    private String subCategoryImage;
    @Column(name = "description")
    private String description;
    @ManyToOne
    @JoinColumn(name = "category_id", referencedColumnName = "id")
    private ExerciseCategoryModel category;
    @ManyToOne
    @JoinColumn(name = "mode_id", referencedColumnName = "id")
    private ExerciseModeModel mode;
}
