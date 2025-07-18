package com.example.Project4.entity.auth;

import com.example.Project4.entity.bmi.PersonHealGoalModel;
import com.example.Project4.entity.bmi.PersonHealModel;
import com.example.Project4.entity.exercise.ExerciseProgressModel;
import com.example.Project4.entity.exercise.ExerciseScheduleModel;
import com.example.Project4.entity.exercise.FavoritesModel;
import com.example.Project4.entity.meal.UserMealsModel;
import com.example.Project4.entity.product.Order;
import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false, unique = true, length = 30)
    @Size(min = 3, max = 30, message = "USERNAME_INVALID")
    private String username;

    @Column(nullable = false, length = 128)
    private String password;

    @Column(nullable = true, length = 128)
    private String firstName;

    @Column(nullable = true, length = 128)
    private String lastName;

    @Column(unique = true, nullable = false, length = 128)
    private String email;

    @Column(unique = true, nullable = true, length = 14)
    private String phone;

    @Column(nullable = true)
    private int gender;

    @Column(nullable = true, length = 128)
    private String address;

    @Builder.Default
    private boolean active = false;

    private LocalDate dob;

    @ManyToOne()
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @OneToMany(mappedBy = "user",cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<UserMealsModel> meals;

    @OneToMany(mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<ExerciseProgressModel> progress;

    @OneToMany( mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<PersonHealModel> health;

    @OneToMany( mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<PersonHealGoalModel> healthGoal;

    @OneToMany( mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<FavoritesModel> favorite;

    @OneToMany(mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<ExerciseScheduleModel> schedules;

    @OneToMany( mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<Order> orders;
}
