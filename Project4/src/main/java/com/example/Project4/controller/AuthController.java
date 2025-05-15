package com.example.Project4.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.Project4.dto.auth.LoginRequest;
import com.example.Project4.dto.auth.RegisterRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.services.auth.AuthService;

import java.util.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @GetMapping("/getUsers")
    public List<UserModel> getUsers() {
        return authService.getAllUser();
    }

    @GetMapping("/getUser/{id}")
    public ResponseEntity<?> getUser(@PathVariable("id") int id) {
        var user = authService.getUserById(id);
        return ResponseEntity.status(200).body(user);
    }

    @PostMapping("/login")
    public ResponseEntity<?> checkLogin(@RequestBody LoginRequest loginRequest) {
        var user = authService.login(loginRequest);
        return ResponseEntity.ok(user);
    }

    @PostMapping("/register")
    public ResponseEntity<?> regiser(@RequestBody RegisterRequest registerRequest) {
        var user = authService.register(registerRequest);
        return ResponseEntity.ok(user);
    }

    @PutMapping("/verify")
    public ResponseEntity<?> verifyEmail(@RequestBody Map<String,String> payload) {
        var verify = authService.verifyEmail(payload);
        return ResponseEntity.ok(verify);
    }
}
