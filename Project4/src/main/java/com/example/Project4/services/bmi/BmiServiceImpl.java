package com.example.Project4.services.bmi;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.dto.bmi.PersonHealDataRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.bmi.PersonHealModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.bmi.PersonHealRepository;

@Service
public class BmiServiceImpl implements BmiService{
        @Autowired
    private PersonHealRepository pRepository;
    @Autowired
    private UserRepository userRepository;
    @Override
    public UserModel saveData(PersonHealDataRequest dto, int userid) {
        UserModel user = userRepository.findById(userid).orElse(null);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        if (user.getBmiid() == null) {
            PersonHealModel health = new PersonHealModel();
            health.setHeight(dto.getHeight());
            health.setWeight(dto.getWeight());
            health.setBmi((dto.getWeight() / Math.pow(dto.getHeight(), 2)) * 10000);
            PersonHealModel savedHealth = pRepository.save(health);
            user.setBmiid(savedHealth);
            user.setCreatedAt(LocalDateTime.now());
            userRepository.save(user);
            return user;
        } else {
            throw new RuntimeException("User have already BMI");
        }
    }
}
