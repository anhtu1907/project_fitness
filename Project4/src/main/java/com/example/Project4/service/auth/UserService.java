package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.example.Project4.entity.auth.User;
import com.example.Project4.exception.ApiException;

import java.util.List;

public interface UserService {
    UserResponse create(UserCreationRequest request);

    void activateAccount(String token) throws ApiException;

    List<UserResponse> getAll();

    User getById(String userId);

    User getByUsername(String username);

    User getByEmail(String email);

    User update(String userId , UserUpdateRequest userUpdateRequest);

    void delete(String userId);
}
