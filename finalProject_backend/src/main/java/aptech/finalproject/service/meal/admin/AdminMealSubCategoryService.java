package aptech.finalproject.service.meal.admin;

import aptech.finalproject.dto.request.meal.MealSubCategoryRequest;
import aptech.finalproject.dto.response.meal.MealSubCategoryResponse;

import java.util.List;

public interface AdminMealSubCategoryService {

    MealSubCategoryResponse create(MealSubCategoryRequest request);
    MealSubCategoryResponse update(Integer id, MealSubCategoryRequest request);
    MealSubCategoryResponse getById(Integer id);
    void deleteById(Integer id);
    List<MealSubCategoryResponse> getAll();
}
