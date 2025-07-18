package com.example.Project4.dto.bmi;

import lombok.*;
import java.time.LocalDateTime;

import com.example.Project4.dto.auth.UserDTO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class PersonalHealthGoalDTO {
     private int id;
    private UserDTO user;
    private double targetWeight;
    private LocalDateTime createdAt;
}
