package aptech.finalproject.dto.response.exercise;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExercisesResponse {
    private int id;
    private String exerciseName;
    private String exerciseImage;
    private String description;
    private int duration;
    private double kcal;
    private Set<Integer> subCategoryIds;
    private Integer equipmentId;
    private Set<Integer> modeIds;
}