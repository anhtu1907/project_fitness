package com.example.Project4.models.exercise;

import java.time.LocalDateTime;

import com.example.Project4.models.auth.UserModel;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_schedule")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseScheduleModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private UserModel user;
    @ManyToOne
    @JoinColumn(name = "sub_category_id", referencedColumnName = "id")
    private ExerciseSubCategoryModel subCategory;
    @Column(name = "schedule_time")
    private LocalDateTime scheduleTime;
}
