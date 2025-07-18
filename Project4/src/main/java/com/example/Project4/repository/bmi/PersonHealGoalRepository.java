package com.example.Project4.repository.bmi;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.entity.bmi.PersonHealGoalModel;

@Repository
public interface PersonHealGoalRepository extends JpaRepository<PersonHealGoalModel, Integer>{
    PersonHealGoalModel findTopByUserIdOrderByCreatedAtDesc(String userId);
    List<PersonHealGoalModel> findAllGoalByUserId(String userId);
}
