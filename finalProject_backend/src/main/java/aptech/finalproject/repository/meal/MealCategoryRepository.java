package aptech.finalproject.repository.meal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.meal.MealCategoryModel;

@Repository
public interface MealCategoryRepository extends JpaRepository<MealCategoryModel, Integer>{
    
}
