package com.example.Project4.services.auth;

import java.util.List;
import java.util.Map;

import com.example.Project4.payload.auth.LoginRequest;
import com.example.Project4.payload.auth.RegisterRequest;
import com.example.Project4.models.auth.UserModel;

public interface AuthService {
    List<UserModel> getAllUser();
    UserModel getUserById(int userId);
    UserModel login(LoginRequest loginRequest);
    UserModel register(RegisterRequest registerRequest);
    String verifyEmail(Map<String, String> payload);
}
