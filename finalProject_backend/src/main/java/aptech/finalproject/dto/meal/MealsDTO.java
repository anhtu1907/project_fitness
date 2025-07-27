package aptech.finalproject.dto.meal;

import java.util.Set;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealsDTO {
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
    private Set<MealSubCategoryDTO> subCategory;
    private Set<MealTimeDTO> timeOfDay;

}
