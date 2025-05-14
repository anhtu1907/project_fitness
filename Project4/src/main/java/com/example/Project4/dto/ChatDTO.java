package com.example.Project4.dto;

import lombok.*;
@Getter
@Setter
public class ChatDTO {
    private int senderId;
    private int receiverId;
    private String message;
    private String status;
}
