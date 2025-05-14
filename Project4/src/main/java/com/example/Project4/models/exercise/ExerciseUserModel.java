package com.example.Project4.models.exercise;

import java.time.LocalDateTime;

import com.example.Project4.models.auth.UserModel;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_user")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseUserModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private UserModel user;
    @ManyToOne
    @JoinColumn(name = "session_id", referencedColumnName = "id")
    private ExerciseSessionModel session;
    @Column(name = "kcal")
    private double kcal;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
