package com.example.Project4.repository.bmi;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Project4.models.bmi.PersonHealModel;

public interface PersonHealRepository extends JpaRepository<PersonHealModel, Integer> {
    
}
