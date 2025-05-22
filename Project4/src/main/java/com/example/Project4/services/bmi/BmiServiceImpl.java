package com.example.Project4.services.bmi;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.payload.bmi.PersonHealDataRequest;
import com.example.Project4.payload.bmi.PersonTargetGoalRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.bmi.PersonHealGoalModel;
import com.example.Project4.models.bmi.PersonHealModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.bmi.PersonHealGoalRepository;
import com.example.Project4.repository.bmi.PersonHealRepository;

@Service
public class BmiServiceImpl implements BmiService {
    @Autowired
    private PersonHealRepository pRepository;
    @Autowired
    private PersonHealGoalRepository goalRepository;
    @Autowired
    private UserRepository userRepository;


    @Override
    public UserModel saveData(PersonHealDataRequest dto, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        if (user.getBmi() == null) {
            PersonHealModel health = new PersonHealModel();
            health.setHeight(dto.getHeight());
            health.setWeight(dto.getWeight());
            health.setBmi((dto.getWeight() / Math.pow(dto.getHeight(), 2)) * 10000);
            health.setCreatedAt(LocalDateTime.now());
            PersonHealModel savedHealth = pRepository.save(health);
            user.setBmi(savedHealth);
            userRepository.save(user);
            return user;
        } else {
            throw new RuntimeException("User have already BMI");
        }
    }

    @Override
    public PersonHealModel updateData(PersonTargetGoalRequest req, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        PersonHealModel health = new PersonHealModel();
        health.setWeight(req.getTargetWeight());
        health.setUpdatedAt(LocalDateTime.now());
        pRepository.save(health);
        return health;
    }

    @Override
    public PersonHealGoalModel saveGoal(PersonTargetGoalRequest req, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        Optional<PersonHealGoalModel> existingGoal = goalRepository.findByUser(user);
        if (existingGoal.isPresent()) {
        throw new RuntimeException("User already has a BMI Goal");
    }
    PersonHealGoalModel goal = new PersonHealGoalModel();   
        goal.setUser(user);
        goal.setTargetWeight(req.getTargetWeight());
        goal.setCreatedAt(LocalDateTime.now());
        goalRepository.save(goal);
        return goal;
    }
    @Override
    public PersonHealGoalModel updateGoal(PersonTargetGoalRequest req, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        PersonHealGoalModel goal = new PersonHealGoalModel();
        goal.setTargetWeight(req.getTargetWeight());
        goal.setUpdatedAt(LocalDateTime.now());
        goalRepository.save(goal);
        return goal;
    }

    @Override
    public PersonHealGoalModel getGoalByUserId(int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        return goalRepository.findByUserId(user.getId());
    }
}
