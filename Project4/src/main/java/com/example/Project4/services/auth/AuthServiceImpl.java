package com.example.Project4.services.auth;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.Project4.payload.auth.LoginRequest;
import com.example.Project4.payload.auth.RegisterRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.services.MailService;
import com.example.Project4.utils.AccountDisabledException;
import com.example.Project4.utils.EmailNotFoundException;
import com.example.Project4.utils.IncorrectPasswordException;

@Service
public class AuthServiceImpl implements AuthService {
        @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private MailService mailService;
    @Override
    public List<UserModel> getAllUser() {
        return userRepository.findAll();
    }

    @Override
    public UserModel getUserById(int userId) {
        return userRepository.findById(userId).orElseThrow(null);
        
    }

    @Override
    public UserModel login(LoginRequest loginRequest) {
        UserModel user = userRepository.findByEmail(loginRequest.getEmail());
        passwordEncoder = new BCryptPasswordEncoder();
        if (user == null) {
            throw new EmailNotFoundException("Email not found");
        }
        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            throw new IncorrectPasswordException("Incorrect password");
        }
        if (!user.isStatus()) {
            throw new AccountDisabledException("Account is disabled");
        }
        return user;
    }

    @Override
    public UserModel register(RegisterRequest registerRequest) {
        if (userRepository.findByEmail(registerRequest.getEmail()) != null) {
            throw new RuntimeException("Email already exists");
        }
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (var i = 0; i < 6; i++) {
            code.append(random.nextInt(10));
        }
        UserModel user = new UserModel();
        user.setFirstname(registerRequest.getFirstname());
        user.setLastname(registerRequest.getLastname());
        user.setEmail(registerRequest.getEmail());
        String hashPassword = passwordEncoder.encode(registerRequest.getPassword());
        user.setPassword(hashPassword);
        user.setDob(registerRequest.getDob());
        user.setGender(registerRequest.getGender());
        user.setImage(registerRequest.getImage());
        user.setPhone(registerRequest.getPhone());
        user.setToken("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzQ1MjQ4ODc3LCJleHAiOjE3NDUyNTI0Nzd9.v8aHvgT78FCYo9p-XILy0PEccQpWdNHjClMaK955LQ8");
        user.setPinCode(code.toString());
        user.setStatus(false);
        user.setRoleid(2);
        user.setCreatedAt(LocalDateTime.now());

        var isSucess = userRepository.save(user);
        System.out.println("Saved user: " + isSucess);
        if (isSucess != null) {
            String to = user.getEmail();
            String subject = "Verify Email";
            String body = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>Verify Your Email</title>
            </head>
            <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
                <div style="max-width: 600px; margin: 20px auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1);">
                    <h2 style="text-align: center; color: #333;">Xác Minh Email</h2>
                    <p style="font-size: 16px; text-align: center;">Cảm ơn bạn đã đăng ký. Vui lòng sử dụng mã xác minh sau để kích hoạt tài khoản của bạn:</p>
                    
                    <div style="text-align: center; margin: 20px 0;">
                        <span style="display: inline-block; font-size: 24px; font-weight: bold; color: #ff6600; padding: 10px 20px; border: 2px solid #ff6600; border-radius: 5px;">
                            """ + user.getPinCode() + """
                        </span>
                    </div>

                    <p style="font-size: 14px; text-align: center; color: #666;">Mã xác minh có hiệu lực trong 10 phút.</p>
                    
                    <hr style="border: none; border-top: 1px solid #ddd;">
                    <p style="text-align: center; font-size: 12px; color: #888;">Nếu bạn không yêu cầu email này, vui lòng bỏ qua.</p>
                </div>
            </body>
            </html>
        """;
            mailService.sendEmail(to, subject, body);
        }
        return user;
    }

    @Override
    public String verifyEmail(Map<String, String> payload) {
        String code = payload.get("code");
        String email = payload.get("email");    
        UserModel user = userRepository.findByCode(code.trim(), email);

        if (user == null) {
            throw new RuntimeException("Invalid verification code");
        }
        user.setPinCode(null);
        user.setStatus(true);

        userRepository.save(user);
        return "Email verified successfully!";
    }


}
