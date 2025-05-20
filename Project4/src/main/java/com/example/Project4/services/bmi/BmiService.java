package com.example.Project4.services.bmi;


import com.example.Project4.dto.bmi.PersonHealDataRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.bmi.PersonHealGoalModel;
import com.example.Project4.models.bmi.PersonHealModel;

public interface BmiService {
    UserModel saveData(PersonHealDataRequest dto,int userId);
    PersonHealModel updateData(int weight, int userId);
    PersonHealGoalModel saveGoal(int targetWeight, int userId);
    PersonHealGoalModel updateGoal(int targetWeight, int userId);
}
