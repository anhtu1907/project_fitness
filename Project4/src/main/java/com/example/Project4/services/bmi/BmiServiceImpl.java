package com.example.Project4.services.bmi;

import java.time.LocalDateTime;
import java.util.List;

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
    public PersonHealModel saveData(PersonHealDataRequest dto, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        PersonHealModel healthUser = pRepository.findTopByUserIdOrderByCreatedAtDesc(userId);
        if (healthUser == null) {
            PersonHealModel health = new PersonHealModel();
            health.setUser(user);
            health.setHeight(dto.getHeight());
            health.setWeight(dto.getWeight());
            health.setBmi((dto.getWeight() / Math.pow(dto.getHeight(), 2)) * 10000);
            health.setCreatedAt(LocalDateTime.now());
            pRepository.save(health);
            return health;
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
        PersonHealModel oldHealth = pRepository.findTopByUserIdOrderByCreatedAtDesc(userId);
        if (oldHealth == null) {
            throw new RuntimeException("No health record found for user");
        }
        PersonHealModel newHealth = new PersonHealModel();
        newHealth.setUser(user);
        newHealth.setHeight(oldHealth.getHeight());
        newHealth.setWeight(req.getTargetWeight());
        newHealth.setBmi((req.getTargetWeight() / Math.pow(oldHealth.getHeight(), 2)) * 10000);
        newHealth.setCreatedAt(LocalDateTime.now());
        pRepository.save(newHealth);
        return newHealth;
    }

    @Override
    public PersonHealGoalModel saveGoal(PersonTargetGoalRequest req, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        PersonHealGoalModel goalUser = goalRepository.findTopByUserIdOrderByCreatedAtDesc(userId);
        if (goalUser == null) {
            PersonHealGoalModel goal = new PersonHealGoalModel();
            goal.setUser(user);
            goal.setTargetWeight(req.getTargetWeight());
            goal.setCreatedAt(LocalDateTime.now());
            goalRepository.save(goal);
            return goal;
        } else {
            throw new RuntimeException("User have already BMI Goal");
        }

    }

    @Override
    public PersonHealGoalModel updateGoal(PersonTargetGoalRequest req, int userId) {
        UserModel user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        PersonHealGoalModel oldGoallUser = goalRepository.findTopByUserIdOrderByCreatedAtDesc(userId);
        if (oldGoallUser == null) {
            throw new RuntimeException("No goal record found for user");
        }
        PersonHealGoalModel newGoal = new PersonHealGoalModel();
        newGoal.setUser(user);
        newGoal.setTargetWeight(req.getTargetWeight());
        newGoal.setCreatedAt(LocalDateTime.now());
        goalRepository.save(newGoal);
        return newGoal;
    }

    @Override
    public List<PersonHealModel> getDataByUserId(int userId) {
        return pRepository.findAllHealthByUserId(userId);
    }

    @Override
    public List<PersonHealGoalModel> getGoalByUserId(int userId) {
        return goalRepository.findAllGoalByUserId(userId);
    }

}
