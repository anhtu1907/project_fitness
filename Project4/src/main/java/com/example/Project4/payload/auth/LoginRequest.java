package com.example.Project4.payload.auth;

import lombok.*;

@Getter
@Setter
public class LoginRequest {
    private String email;
    // private String username;
    private String password;
}
