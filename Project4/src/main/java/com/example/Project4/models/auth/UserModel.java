package com.example.Project4.models.auth;

import java.time.LocalDateTime;

import com.example.Project4.models.bmi.PersonHealModel;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String firstname;
    private String lastname;
    private String email;
    private String password;
    private String image;
    private LocalDateTime dob;
    private Integer gender;
    private String phone;
    @Column(name = "token")
    private String token;
    @Column(name = "pin_code")
    private String pinCode;
    private boolean status;
    @Column(name = "role_id")
    private Integer roleid;
    @OneToOne
    @JoinColumn(name = "bmi_id", referencedColumnName = "id")
    private PersonHealModel bmiid;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
