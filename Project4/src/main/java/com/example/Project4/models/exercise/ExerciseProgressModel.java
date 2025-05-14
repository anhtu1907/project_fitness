package com.example.Project4.models.exercise;

import java.time.LocalDateTime;

import com.example.Project4.models.auth.UserModel;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercise_progress")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseProgressModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private UserModel user;
    @ManyToOne
    @JoinColumn(name = "session_id", referencedColumnName = "id")
    private ExerciseSessionModel exercise;
    @Column(name = "progress_percent")
    private double progress;
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
}
