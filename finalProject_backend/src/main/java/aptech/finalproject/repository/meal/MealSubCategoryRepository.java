package aptech.finalproject.repository.meal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.meal.MealSubCategoryModel;

@Repository
public interface MealSubCategoryRepository extends JpaRepository<MealSubCategoryModel, Integer> {
    
}
