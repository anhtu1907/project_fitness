package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.exercise.ExerciseSessionModel;

@Repository
public interface ExerciseSessionRepository extends JpaRepository<ExerciseSessionModel, Integer> {
    @Query("SELECT e FROM ExerciseSessionModel e WHERE e.user.id = :userId AND e.exercise.id = :exerciseId AND e.resetBatch = :resetBatch")
    List<ExerciseSessionModel> findByUserAndExerciseAndResetBatch(int userId, int exerciseId, int resetBatch);
    @Query("SELECT COUNT(es) FROM ExerciseSessionModel es where es.user.id = :userId AND es.exercise.subCategory.id = :subCategoryId AND es.resetBatch =:resetBatch")
    int countByUserIdAndSubCategoryIdAndResetBatch(int userId, int subCategoryId,int resetBatch);

    List<ExerciseSessionModel> findAllSessionByUserId(int userId);
}
