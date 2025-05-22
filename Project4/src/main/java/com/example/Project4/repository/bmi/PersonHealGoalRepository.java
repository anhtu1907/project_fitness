package com.example.Project4.repository.bmi;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.bmi.PersonHealGoalModel;

@Repository
public interface PersonHealGoalRepository extends JpaRepository<PersonHealGoalModel, Integer>{
    PersonHealGoalModel findByUserId(int userId);
    Optional<PersonHealGoalModel> findByUser(UserModel user);
}
