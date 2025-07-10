package com.example.Project4.dto.meal;

import java.util.List;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealCategoryDTO {
    private int id;
    private String categoryImage;
    private String categoryName;
    private List<MealSubCategoryDTO> subCategories;
}
