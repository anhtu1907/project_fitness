package com.example.Project4.controller.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.example.Project4.entity.auth.*;
import com.example.Project4.exception.ErrorCode;
import com.example.Project4.mapper.auth.UserMapper;
import com.example.Project4.service.auth.UserService;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/identity/user")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private UserMapper userMapper;

    @PostMapping("/create")
    public ApiResponse<UserResponse> create(@RequestBody @Valid UserCreationRequest userCreationRequest,
                                            BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        UserResponse user = userService.create(userCreationRequest);
        if (user == null) {
            return ApiResponse.badRequest(ErrorCode.USER_CREATION_FAILED.getException());
        }
        return ApiResponse.created(user, "Created user");
    }

    @GetMapping()
    public ApiResponse<List<UserResponse>> getAll() {
        List<UserResponse> users = userService.getAll();
        if(users.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(users, "Get all users");
    }

    @GetMapping("/id/{userId}")
    public ApiResponse<UserResponse> getById(@PathVariable String userId) {
        User user = userService.getById(userId);
        if(user == null) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(userMapper.toUserResponse(user), "Get user by id");
    }

        @GetMapping("/username/{username}")
        public ApiResponse<UserResponse> getByUsername(@PathVariable String username) {
            User user = userService.getByUsername(username);
            if(user == null){
                return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
            }
            return ApiResponse.ok(userMapper.toUserResponse(user), "Get user by username");
        }

    @PutMapping("/{userId}")
    public ApiResponse<UserResponse> update(@PathVariable String userId,
                                            @RequestBody @Valid UserUpdateRequest userUpdateRequest,
                                            BindingResult result) {
        if(result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        User updated = userService.update(userId, userUpdateRequest);
        if (updated == null) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(userMapper.toUserResponse(updated), "Update user");
    }

    @DeleteMapping("/{userId}")
    public ApiResponse<UserResponse> delete(@PathVariable String userId){
        userService.delete(userId);
        return ApiResponse.noContent(String.format("Deleted user with id %s", userId));
    }


}
