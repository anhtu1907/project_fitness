package com.example.Project4.dto;

import lombok.*;

@Getter
@Setter
public class ExerciseSessionRequest {
    private int userId;
    private int exerciseId;
    private int duration;
    private int resetBatch;
}
