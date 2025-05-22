package com.example.Project4.services.bmi;


import com.example.Project4.payload.bmi.PersonHealDataRequest;
import com.example.Project4.payload.bmi.PersonTargetGoalRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.bmi.PersonHealGoalModel;
import com.example.Project4.models.bmi.PersonHealModel;

public interface BmiService {
    UserModel saveData(PersonHealDataRequest dto,int userId);
    PersonHealModel updateData(PersonTargetGoalRequest req, int userId);
    PersonHealGoalModel saveGoal(PersonTargetGoalRequest req, int userId);
    PersonHealGoalModel updateGoal(PersonTargetGoalRequest req, int userId);
    PersonHealGoalModel getGoalByUserId(int userId);
}
