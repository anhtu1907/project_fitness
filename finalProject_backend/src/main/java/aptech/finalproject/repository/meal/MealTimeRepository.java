package aptech.finalproject.repository.meal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.meal.MealTimeModel;

@Repository
public interface MealTimeRepository extends JpaRepository<MealTimeModel,Integer> {
    
}
