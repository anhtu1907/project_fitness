package com.example.Project4.dto.exercise;


import com.example.Project4.dto.meal.UserSimpleDTO;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FavoritesDTO {
    private int id;
    private String favoriteName;
    private UserSimpleDTO user;
}
