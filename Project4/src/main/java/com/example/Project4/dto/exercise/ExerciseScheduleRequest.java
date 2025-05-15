package com.example.Project4.dto.exercise;

import java.time.LocalDateTime;

import lombok.*;

@Getter
@Setter
public class ExerciseScheduleRequest {
    private int user;
    private int subCategory;
    private LocalDateTime scheduleTime;
}
