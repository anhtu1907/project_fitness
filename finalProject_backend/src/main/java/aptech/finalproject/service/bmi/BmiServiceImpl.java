package aptech.finalproject.service.bmi;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import aptech.finalproject.dto.bmi.PersonalHealthDTO;
import aptech.finalproject.dto.bmi.PersonalHealthGoalDTO;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.bmi.PersonHealGoalModel;
import aptech.finalproject.entity.bmi.PersonHealModel;
import aptech.finalproject.mapper.BmiMapper;
import aptech.finalproject.payload.bmi.PersonHealDataRequest;
import aptech.finalproject.payload.bmi.PersonTargetGoalRequest;
import aptech.finalproject.repository.*;
import aptech.finalproject.repository.bmi.PersonHealGoalRepository;
import aptech.finalproject.repository.bmi.PersonHealRepository;

@Service
public class BmiServiceImpl implements BmiService {
    @Autowired
    private PersonHealRepository pRepository;
    @Autowired
    private PersonHealGoalRepository goalRepository;
    @Autowired
    private UserRepository userRepository;

    @Override
    public PersonalHealthDTO saveData(PersonHealDataRequest dto, String userId) {
        User user = userRepository.findById(userId).orElse(null);
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
            return BmiMapper.toHealthDTO(health);
        } else {
            throw new RuntimeException("User have already BMI");
        }
    }

    @Override
    public PersonalHealthDTO updateData(PersonTargetGoalRequest req, String userId) {
        User user = userRepository.findById(userId).orElse(null);
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
        return BmiMapper.toHealthDTO(newHealth);
    }

    @Override
    public PersonalHealthGoalDTO saveGoal(PersonTargetGoalRequest req, String userId) {
        User user = userRepository.findById(userId).orElse(null);
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
            return BmiMapper.toGoalDTO(goal);
        } else {
            throw new RuntimeException("User have already BMI Goal");
        }

    }

    @Override
    public PersonalHealthGoalDTO updateGoal(PersonTargetGoalRequest req, String userId) {
        User user = userRepository.findById(userId).orElse(null);
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
        return BmiMapper.toGoalDTO(newGoal);
    }

    @Override
    public List<PersonalHealthDTO> getDataByUserId(String userId) {
        return pRepository.findAllHealthByUserId(userId).stream().map(BmiMapper::toHealthDTO).collect(Collectors.toList());
    }

    @Override
    public List<PersonalHealthGoalDTO> getGoalByUserId(String userId) {
        return goalRepository.findAllGoalByUserId(userId).stream().map(BmiMapper::toGoalDTO).collect(Collectors.toList());
    }

}
