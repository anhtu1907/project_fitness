package com.example.Project4.entity.bmi;

import java.time.LocalDateTime;

import com.example.Project4.entity.auth.User;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "health_goal")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PersonHealGoalModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;
    @Column(name = "target_weight")
    private double targetWeight;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
