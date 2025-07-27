package aptech.finalproject.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.exercise.ExercisesModel;

@Repository
public interface ExercisesRepository extends JpaRepository<ExercisesModel,Integer>{
    List<ExercisesModel> findAllBySubCategoryId(int subCategoryId);
    long countBySubCategoryId(int subCategoryId);
    @Query("SELECT DISTINCT e FROM ExercisesModel e LEFT JOIN FETCH e.subCategory LEFT JOIN FETCH e.modes")
    List<ExercisesModel> findAllWithSubCategoryAndModes();
    List<ExercisesModel> findByExerciseNameContainingIgnoreCase(String name);
    Long countByEquipmentId(int equipmentId);
}
