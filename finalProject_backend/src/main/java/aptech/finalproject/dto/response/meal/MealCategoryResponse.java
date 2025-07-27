package aptech.finalproject.dto.response.meal;

import lombok.*;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealCategoryResponse {
    private int id;
    private String categoryImage;
    private String categoryName;
    private List<Integer> subCategoryIds;
}