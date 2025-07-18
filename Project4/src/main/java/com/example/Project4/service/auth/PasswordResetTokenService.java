package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.ResetPasswordRequest;
import  com.example.Project4.exception.ApiException;

public interface PasswordResetTokenService {
    void sendResetPasswordLink(String email);
    void resetPassword(ResetPasswordRequest request) throws ApiException;
}
