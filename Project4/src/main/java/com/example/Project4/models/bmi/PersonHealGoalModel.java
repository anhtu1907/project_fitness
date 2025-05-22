package com.example.Project4.models.bmi;

import java.time.LocalDateTime;


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
    @Column(name = "target_weight")
    private double targetWeight;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
