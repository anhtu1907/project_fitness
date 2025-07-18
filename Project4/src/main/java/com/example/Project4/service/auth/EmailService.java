package com.example.Project4.service.auth;

public interface EmailService {
    void send(String to, String subject, String body);
    void sendHtml(String to, String subject, String body);
}
