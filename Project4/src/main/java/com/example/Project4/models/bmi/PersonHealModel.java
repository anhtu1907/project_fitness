package com.example.Project4.models.bmi;

import java.time.LocalDateTime;

import com.example.Project4.models.auth.UserModel;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "healths")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PersonHealModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private UserModel user;
    private double height;
    private double weight;
    private double bmi;
    @Column(name = "created_at")
    private LocalDateTime createdAt;

}
