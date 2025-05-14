package com.example.Project4.models.meal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Table(name="meal_category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealCategoryModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "category_image")
    private String categoryImage;
    @Column(name = "category_name")
    private String categoryName;
}
