package com.example.Project4.payload.meal;


import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserMealsRequest {
    private int user;
    private List<Integer> meal;
}
