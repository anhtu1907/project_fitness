package com.example.Project4.dto.auth;


import java.time.LocalDateTime;

import lombok.*;

@Getter
@Setter
public class RegisterRequest {
    private String firstname;
    private String lastname;
    private String email;
    private String password;
    private String image;
    private LocalDateTime dob;
    private int gender;
    private String phone;
    private String token;
    private String pinCode;
    private boolean status;
    private int roleid;
    private int bmmid;
}
