package com.example.Project4.models.exercise;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercise_mode")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseModeModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "mode_name")
    private String modeName;
}
