package aptech.finalproject.dto.response.exercise;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseSubCategoryResponse {
    private int id;
    private String subCategoryName;
    private String subCategoryImage;
    private String description;
    private Set<Integer> categoryIds;
    private Set<Integer> exerciseIds;
    private List<Integer> scheduleIds;
}
