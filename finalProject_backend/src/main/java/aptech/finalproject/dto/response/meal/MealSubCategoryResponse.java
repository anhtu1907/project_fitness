package aptech.finalproject.dto.response.meal;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealSubCategoryResponse {
    private int id;
    private String subCategoryName;
    private String subCategoryImage;
    private String description;
    private int categoryId;
}