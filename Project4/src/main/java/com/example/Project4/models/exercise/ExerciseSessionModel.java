package com.example.Project4.models.exercise;

import java.time.LocalDateTime;

import com.example.Project4.models.auth.UserModel;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_session")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSessionModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private UserModel user;
    @ManyToOne
    @JoinColumn(name = "exercise_id", referencedColumnName = "id")
    private ExercisesModel exercise;
    @Column(name = "kcal")
    private double kcal;
    @Column(name = "reset_batch")
    private int resetBatch = 0;
    @Column(name = "duration")
    private int duration;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
