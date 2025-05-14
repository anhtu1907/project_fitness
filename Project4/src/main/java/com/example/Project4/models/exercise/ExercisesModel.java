package com.example.Project4.models.exercise;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercises")
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
    @ManyToOne
    @JoinColumn(name = "sub_category_id", referencedColumnName = "id")
    private ExerciseSubCategoyrModel subCategory;
}
