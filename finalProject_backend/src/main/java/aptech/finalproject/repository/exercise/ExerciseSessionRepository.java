package aptech.finalproject.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.exercise.ExerciseSessionModel;

@Repository
public interface ExerciseSessionRepository extends JpaRepository<ExerciseSessionModel, Integer> {
    @Query("SELECT e FROM ExerciseSessionModel e WHERE e.user.id = :userId AND e.exercise.id = :exerciseId AND e.resetBatch = :resetBatch")
    List<ExerciseSessionModel> findByUserAndExerciseAndResetBatch(String userId, int exerciseId, int resetBatch);

   @Query("""
    SELECT COUNT(es)
    FROM ExerciseSessionModel es
    WHERE es.user.id = :userId
      AND es.subCategory.id = :subCategoryId
      AND es.resetBatch = :resetBatch
""")
    int countByUserIdAndSubCategoryIdAndResetBatch(String userId, int subCategoryId, int resetBatch);
@Query("""
    SELECT COUNT(es)
    FROM ExerciseSessionModel es
    JOIN es.exercise.subCategory sc
    WHERE es.user.id = :userId
      AND sc.id = :subCategoryId
      AND es.resetBatch = :resetBatch
""")
int countCompletedInSubCategory(String userId, int subCategoryId, int resetBatch);
    List<ExerciseSessionModel> findAllSessionByUserId(String userId);
}
