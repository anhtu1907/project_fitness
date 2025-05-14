package com.example.Project4.models.meal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Table(name = "meals")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealsModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name="meal_name")
    private String mealName;
    @Column(name="meal_image")
    private String mealImage;
    @Column(name="weight")
    private double weight;
    @Column(name="kcal")
    private double kcal;
    @Column(name="protein")
    private double protein;
    @Column(name="fat")
    private double fat;
    @Column(name="carbonhydrate")
    private double carbonhydrate;
    @Column(name="fiber")
    private double fiber;
    @Column(name="sugar")
    private double sugar;
    @ManyToOne
    @JoinColumn(name = "sub_category_id", referencedColumnName = "id")
    private MealSubCategoryModel subCategory;
    @ManyToOne
    @JoinColumn(name = "time_id", referencedColumnName = "id")
    private MealTimeModel timeOfDay;
}
