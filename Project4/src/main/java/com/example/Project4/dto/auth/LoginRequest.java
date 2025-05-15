package com.example.Project4.dto.auth;

import lombok.*;

@Getter
@Setter
public class LoginRequest {
    private String email;
    private String password;
}
