package com.example.Project4.models.meal;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "meal_sub_category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealSubCategoryModel {
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
    private MealCategoryModel category;
}
