package com.example.Project4.repository.meal;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.meal.UserMealsModel;

import jakarta.transaction.Transactional;

@Repository
public interface UserMealsRepository extends JpaRepository<UserMealsModel, Integer> {
    List<UserMealsModel> findByUserId(int userId);

    @Modifying
    @Transactional
    @Query(value = "DELETE FROM user_meals WHERE user_id = :userId AND CONVERT(date, created_at) = :targetDate", nativeQuery = true)
    void deleteAllByUserIdAndCreatedAtDate(@Param("userId") int userId, @Param("targetDate") LocalDate targetDate);
//     @Query(value = "DELETE FROM user_meals WHERE user_id = :userId AND DATE(created_at) = :targetDate", nativeQuery = true)
// void deleteAllByUserIdAndCreatedAtDate(@Param("userId") int userId, @Param("targetDate") LocalDate targetDate);
}
