package aptech.finalproject.entity.meal;

import java.time.LocalDateTime;

import aptech.finalproject.entity.auth.User;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Table(name = "user_meals")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserMealsModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;
    @ManyToOne
    @JoinColumn(name = "meal_id", referencedColumnName = "id")
    private MealsModel meal;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
