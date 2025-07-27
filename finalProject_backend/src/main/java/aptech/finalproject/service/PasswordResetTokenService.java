package aptech.finalproject.service;

import aptech.finalproject.dto.request.ResetPasswordRequest;
import aptech.finalproject.exception.ApiException;

public interface PasswordResetTokenService {
    void sendResetPasswordLink(String email);
    void resetPassword(ResetPasswordRequest request) throws ApiException;
}
