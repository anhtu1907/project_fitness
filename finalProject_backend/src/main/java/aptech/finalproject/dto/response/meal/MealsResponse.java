package aptech.finalproject.dto.response.meal;

import lombok.*;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealsResponse {
    private int id;
    private String mealName;
    private String mealImage;
    private double weight;
    private double kcal;
    private double protein;
    private double fat;
    private double carbonhydrate;
    private double fiber;
    private double sugar;
    private Set<Integer> subCategoryIds;
    private Set<Integer> timeOfDayIds;
}