package com.example.Project4.dto.exercise;
import java.time.LocalDateTime;

import com.example.Project4.dto.meal.UserSimpleDTO;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseUserDTO {
    private int id;
    private UserSimpleDTO user;
    private ExerciseSessionDTO session;
    private double kcal;
    private LocalDateTime createdAt;
}
