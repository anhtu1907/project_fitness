package aptech.finalproject.dto.request.meal;

import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MealsRequest {

    @NotBlank(message = "Meal name must not be blank")
    private String mealName;

    private MultipartFile mealImage;

    @NotNull(message = "Weight is required")
    @Positive(message = "Weight must be a positive number")
    private Double weight;

    @NotNull(message = "Kcal is required")
    @PositiveOrZero(message = "Kcal must be zero or positive")
    private Double kcal;

    @NotNull(message = "Protein is required")
    @PositiveOrZero(message = "Protein must be zero or positive")
    private Double protein;

    @NotNull(message = "Fat is required")
    @PositiveOrZero(message = "Fat must be zero or positive")
    private Double fat;

    @NotNull(message = "Carbohydrate is required")
    @PositiveOrZero(message = "Carbohydrate must be zero or positive")
    private Double carbonhydrate;

    @NotNull(message = "Fiber is required")
    @PositiveOrZero(message = "Fiber must be zero or positive")
    private Double fiber;

    @NotNull(message = "Sugar is required")
    @PositiveOrZero(message = "Sugar must be zero or positive")
    private Double sugar;

    @NotEmpty(message = "At least one subcategory must be selected")
    private Set<@NotNull(message = "Subcategory ID cannot be null") Integer> subCategoryIds;

    @NotEmpty(message = "At least one time of day must be selected")
    private Set<@NotNull(message = "Time of day ID cannot be null") Integer> timeOfDayIds;
}