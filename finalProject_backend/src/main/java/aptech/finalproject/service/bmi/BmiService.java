package aptech.finalproject.service.bmi;


import aptech.finalproject.dto.bmi.PersonalHealthDTO;
import aptech.finalproject.dto.bmi.PersonalHealthGoalDTO;
import aptech.finalproject.payload.bmi.PersonHealDataRequest;
import aptech.finalproject.payload.bmi.PersonTargetGoalRequest;

import java.util.List;

public interface BmiService {
    List<PersonalHealthDTO> getDataByUserId(String userId);
    PersonalHealthDTO saveData(PersonHealDataRequest dto,String userId);
    PersonalHealthDTO updateData(PersonTargetGoalRequest req, String userId);
    List<PersonalHealthGoalDTO> getGoalByUserId(String userId);
    PersonalHealthGoalDTO saveGoal(PersonTargetGoalRequest req, String userId);
    PersonalHealthGoalDTO updateGoal(PersonTargetGoalRequest req, String userId);
}
