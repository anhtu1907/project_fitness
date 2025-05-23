package com.example.Project4.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.example.Project4.payload.auth.LoginRequest;
import com.example.Project4.payload.auth.RegisterRequest;
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
        try {
            UserModel user = authService.register(registerRequest);
            return ResponseEntity.status(201).body(user);
        } catch (ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(ex.getReason());
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Internal server error");
        }
    }

    @PutMapping("/verify")
    public ResponseEntity<?> verifyEmail(@RequestBody Map<String, String> payload) {
        var verify = authService.verifyEmail(payload);
        return ResponseEntity.ok(verify);
    }
}
