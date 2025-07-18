package com.example.Project4.dto.auth.response;
import com.example.Project4.entity.auth.*;

import lombok.*;

import java.time.LocalDate;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserResponse {

    private String id;

    private String username;

    private String firstName;

    private String lastName;

    private String email;

    private String phone;

    private String address;
    private int gender;

    private LocalDate dob;

    private Role role;
}
