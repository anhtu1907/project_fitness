package com.example.Project4.services.bmi;


import com.example.Project4.payload.bmi.PersonHealDataRequest;
import com.example.Project4.payload.bmi.PersonTargetGoalRequest;

import java.util.List;

import com.example.Project4.models.bmi.PersonHealGoalModel;
import com.example.Project4.models.bmi.PersonHealModel;

public interface BmiService {
    List<PersonHealModel> getDataByUserId(int userId);
    PersonHealModel saveData(PersonHealDataRequest dto,int userId);
    PersonHealModel updateData(PersonTargetGoalRequest req, int userId);
    List<PersonHealGoalModel> getGoalByUserId(int userId);
    PersonHealGoalModel saveGoal(PersonTargetGoalRequest req, int userId);
    PersonHealGoalModel updateGoal(PersonTargetGoalRequest req, int userId);
}
