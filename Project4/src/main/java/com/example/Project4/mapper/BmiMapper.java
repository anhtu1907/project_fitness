package com.example.Project4.mapper;

import com.example.Project4.dto.auth.UserDTO;
import com.example.Project4.dto.bmi.PersonalHealthDTO;
import com.example.Project4.dto.bmi.PersonalHealthGoalDTO;
import com.example.Project4.entity.auth.User;
import com.example.Project4.entity.bmi.PersonHealGoalModel;
import com.example.Project4.entity.bmi.PersonHealModel;

public class BmiMapper {
    public static PersonalHealthDTO toHealthDTO(PersonHealModel model) {
        if (model == null || model.getUser() == null) return null;

        return new PersonalHealthDTO(
            model.getId(),
            toUserDTO(model.getUser()),
            model.getHeight(),
            model.getWeight(),
            model.getBmi(),
            model.getCreatedAt()
        );
    }

     public static UserDTO toUserDTO(User user) {
        if (user == null) return null;

        return UserDTO.builder()
            .id(user.getId())
            .username(user.getUsername())
            .firstName(user.getFirstName())
            .lastName(user.getLastName())
            .email(user.getEmail())
            .phone(user.getPhone())
            .gender(user.getGender())
            .address(user.getAddress())
            .active(user.isActive())
            .dob(user.getDob())
            .build();
    }

    public static PersonHealModel toHealthModel(PersonalHealthDTO dto, User user) {
        if (dto == null || user == null) return null;

        PersonHealModel model = new PersonHealModel();
        model.setId(dto.getId());
        model.setUser(user);
        model.setHeight(dto.getHeight());
        model.setWeight(dto.getWeight());
        model.setBmi(dto.getBmi());
        model.setCreatedAt(dto.getCreatedAt());
        return model;
    }

    // PersonHealGoalModel → DTO
    public static PersonalHealthGoalDTO toGoalDTO(PersonHealGoalModel model) {
        if (model == null || model.getUser() == null) return null;

        return new PersonalHealthGoalDTO(
            model.getId(),
            toUserDTO(model.getUser()),
            model.getTargetWeight(),
            model.getCreatedAt()
        );
    }

}
