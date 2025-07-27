package aptech.finalproject.repository.exercise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.exercise.ExerciseCategoryModel;

@Repository
public interface ExerciseCategoryRepository extends JpaRepository<ExerciseCategoryModel,Integer>{
    
}
