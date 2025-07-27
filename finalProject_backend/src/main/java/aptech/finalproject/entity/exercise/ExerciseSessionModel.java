package aptech.finalproject.entity.exercise;

import java.time.LocalDateTime;

import aptech.finalproject.entity.auth.User;

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
    private User user;
    @ManyToOne
    @JoinColumn(name = "exercise_id", referencedColumnName = "id")
    private ExercisesModel exercise;
    @ManyToOne
    @JoinColumn(name = "sub_category_id", referencedColumnName = "id")
    private ExerciseSubCategoryModel subCategory;
    @Column(name = "kcal")
    private double kcal;
    @Column(name = "reset_batch")
    private int resetBatch = 0;
    @Column(name = "duration")
    private int duration;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
