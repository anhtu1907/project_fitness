package com.example.Project4.entity.exercise;


import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercise_programs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseProgramsModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "program_name")
    private String programName;

}
