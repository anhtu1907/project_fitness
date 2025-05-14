package com.example.Project4.repository.meal;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.meal.UserMealsModel;

@Repository
public interface UserMealsRepository  extends JpaRepository<UserMealsModel, Integer>{
    List<UserMealsModel> findByUserId(int userId);
}
