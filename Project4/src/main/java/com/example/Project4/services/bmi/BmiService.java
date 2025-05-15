package com.example.Project4.services.bmi;


import com.example.Project4.dto.bmi.PersonHealDataRequest;
import com.example.Project4.models.auth.UserModel;

public interface BmiService {
    UserModel saveData(PersonHealDataRequest dto,int userid);
}
