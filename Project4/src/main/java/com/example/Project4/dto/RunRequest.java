package com.example.Project4.dto;

import lombok.*;

@Getter
@Setter
public class RunRequest {
    private float distance;
    private float speed;
    private float time;
    private int userid;
    private int metid;
    private float kcal;
}
