package com.example.Project4.dto.meal;

import java.time.LocalDateTime;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserMealDTO {
    private int id;
    private UserSimpleDTO user;
    private MealsDTO meal;
    private LocalDateTime createdAt;
}
