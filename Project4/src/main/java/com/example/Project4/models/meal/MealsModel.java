package com.example.Project4.models.meal;

import java.util.HashSet;
import java.util.Set;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
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
    @ManyToMany
    @JoinTable(name = "meal_subcategories", 
    joinColumns = @JoinColumn(name = "meal_id"), 
    inverseJoinColumns = @JoinColumn(name = "sub_category_id"))
    private Set<MealSubCategoryModel> subCategory = new HashSet<>();
    @ManyToMany
    @JoinTable(name = "meal_times", 
    joinColumns = @JoinColumn(name = "meal_id"), 
    inverseJoinColumns = @JoinColumn(name = "time_id"))
    private Set<MealTimeModel> timeOfDay = new HashSet<>();
}
