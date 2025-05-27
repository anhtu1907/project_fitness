package com.example.Project4.repository.bmi;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Project4.models.bmi.PersonHealModel;

public interface PersonHealRepository extends JpaRepository<PersonHealModel, Integer> {
    PersonHealModel findTopByUserIdOrderByCreatedAtDesc(int userId);
    List<PersonHealModel> findAllHealthByUserId(int userId);
}
