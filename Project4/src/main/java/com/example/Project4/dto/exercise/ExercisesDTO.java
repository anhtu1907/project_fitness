package com.example.Project4.dto.exercise;
import java.util.Set;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExercisesDTO {
   private int id;
    private String exerciseName;
    private String exerciseImage;
    private String description;
    private int duration;
    private double kcal;
    private Set<ExerciseSubCategoryDTO> subCategory;
    private EquipmentsDTO equipment;
    private ExerciseModeDTO mode;
}
