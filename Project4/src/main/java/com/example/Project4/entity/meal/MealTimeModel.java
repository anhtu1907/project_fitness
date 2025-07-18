package com.example.Project4.entity.meal;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "meal_time")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealTimeModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "name")
    private String timeName;
}
