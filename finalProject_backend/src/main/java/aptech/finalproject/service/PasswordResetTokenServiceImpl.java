package aptech.finalproject.service;

import aptech.finalproject.dto.request.ResetPasswordRequest;
import aptech.finalproject.entity.auth.PasswordResetToken;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.repository.PasswordResetTokenRepository;
import aptech.finalproject.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.UUID;

@Service
@Slf4j
public class PasswordResetTokenServiceImpl implements PasswordResetTokenService {
    @Autowired
    private PasswordResetTokenRepository passwordResetTokenRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    @Value("${frontend.domain}")
    private String frontendDomain;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void sendResetPasswordLink(String email) {
        var user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));

        PasswordResetToken existed = passwordResetTokenRepository.findByUserAndUsed(user, false);

        if (existed != null && existed.getExpiryDate().isAfter(Instant.now())) {
            if(existed.getCreatedAt().isAfter(Instant.now().plusSeconds(60))){
                throw new ApiException(ErrorCode.SEND_EMAIL_AFTER_MINUTE);
            }
            existed.setUsed(true);
            passwordResetTokenRepository.save(existed);
        }

        String token = UUID.randomUUID().toString();

        PasswordResetToken passwordResetToken = PasswordResetToken.builder()
                .token(token)
                .user(user)
                .expiryDate(Instant.now().plusSeconds(600))
                .build();
        passwordResetTokenRepository.save(passwordResetToken);

        String subject = "Password Reset Link";
        String content = String.format(
                "Hi %s,\n\nClick the following link to reset your password:\n%s/reset-password?token=%s\n\nThis link will expire in 10 minutes.",
                user.getUsername(), frontendDomain, token
        );
        emailService.send(email, subject, content);

    }

    public void resetPassword(ResetPasswordRequest request) throws ApiException {
        var token = passwordResetTokenRepository.findByToken(request.getToken())
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_RESET_PASSWORD_TOKEN));

        if (token.isUsed()) {
            throw new ApiException(ErrorCode.RESET_PASSWORD_TOKEN_ALREADY_USED);
        }

        if(token.getExpiryDate().isBefore(Instant.now())) {
            throw new ApiException(ErrorCode.RESET_PASSWORD_TOKEN_EXPIRED);
        }

        String newPassword = request.getPassword();
        User user = token.getUser();
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        token.setUsed(true);
        passwordResetTokenRepository.save(token);

    }
}
