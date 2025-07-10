package com.example.Project4.dto.meal;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealSubCategoryDTO {
    private int id;
    private String subCategoryName;
    private String subCategoryImage;
    private String description;
    private MealCategoryDTO category;
}
