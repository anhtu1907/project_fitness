package aptech.finalproject.dto.response.exercise;

import lombok.*;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseCategoryResponse {
    private int id;
    private String categoryName;
    private String categoryImage;
    private Set<Integer> subCategoryIds;
}