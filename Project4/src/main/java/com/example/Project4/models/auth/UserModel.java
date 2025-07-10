package com.example.Project4.models.auth;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.example.Project4.models.bmi.PersonHealGoalModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
import com.example.Project4.models.exercise.FavoritesModel;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String username;
    private String firstname;
    private String lastname;
    private String email;
    private String password;
    private LocalDateTime dob;
    private Integer gender;
    private String phone;
    @Column(name = "token")
    private String token;
    @Column(name = "pin_code")
    private String pinCode;
    private boolean active;
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<PersonHealGoalModel> healthGoals = new ArrayList<>();
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<FavoritesModel> favorites = new ArrayList<>();
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<ExerciseScheduleModel> schedules = new ArrayList<>();
}
