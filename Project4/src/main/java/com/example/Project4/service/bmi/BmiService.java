package com.example.Project4.service.bmi;


import com.example.Project4.dto.bmi.PersonalHealthDTO;
import com.example.Project4.dto.bmi.PersonalHealthGoalDTO;
import com.example.Project4.payload.bmi.PersonHealDataRequest;
import com.example.Project4.payload.bmi.PersonTargetGoalRequest;

import java.util.List;

public interface BmiService {
    List<PersonalHealthDTO> getDataByUserId(String userId);
    PersonalHealthDTO saveData(PersonHealDataRequest dto,String userId);
    PersonalHealthDTO updateData(PersonTargetGoalRequest req, String userId);
    List<PersonalHealthGoalDTO> getGoalByUserId(String userId);
    PersonalHealthGoalDTO saveGoal(PersonTargetGoalRequest req, String userId);
    PersonalHealthGoalDTO updateGoal(PersonTargetGoalRequest req, String userId);
}
