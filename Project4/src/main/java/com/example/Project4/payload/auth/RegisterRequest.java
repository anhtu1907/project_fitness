package com.example.Project4.payload.auth;


import java.time.LocalDateTime;

import lombok.*;

@Getter
@Setter
public class RegisterRequest {
    private String username;
    private String firstname;
    private String lastname;
    private String email;
    private String password;
    private LocalDateTime dob;
    private int gender;
    private String phone;
    private String token;
    private String pinCode;
    private int bmmid;
}
