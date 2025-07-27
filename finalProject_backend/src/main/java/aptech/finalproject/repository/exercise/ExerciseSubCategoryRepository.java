package aptech.finalproject.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;

@Repository
public interface ExerciseSubCategoryRepository extends JpaRepository<ExerciseSubCategoryModel, Integer> {
    List<ExerciseSubCategoryModel> findBySubCategoryNameLike(String subCategoryName);
}
