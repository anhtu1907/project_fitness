package com.example.Project4.dto.exercise;
import java.util.Set;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSubCategoryDTO {
    private int id;
    private String subCategoryName;
    private String subCategoryImage;
    private String description;
    private Set<ExerciseCategoryDTO> category;
}
