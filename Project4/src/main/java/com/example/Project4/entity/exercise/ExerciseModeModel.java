package com.example.Project4.entity.exercise;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_mode")
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
    @ManyToMany(mappedBy = "modes")
    private Set<ExercisesModel> exercises = new HashSet<>();
}
