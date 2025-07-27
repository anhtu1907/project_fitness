package aptech.finalproject.entity.auth;

import aptech.finalproject.entity.bmi.PersonHealGoalModel;
import aptech.finalproject.entity.bmi.PersonHealModel;
import aptech.finalproject.entity.exercise.ExerciseProgressModel;
import aptech.finalproject.entity.exercise.ExerciseScheduleModel;
import aptech.finalproject.entity.exercise.FavoritesModel;
import aptech.finalproject.entity.meal.UserMealsModel;
import aptech.finalproject.entity.product.Order;
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

    @Column(nullable = true, length = 128)
    private String deliveryAddress;

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
