package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.example.Project4.entity.auth.*;
import com.example.Project4.exception.*;
import com.example.Project4.mapper.auth.*;
import com.example.Project4.repository.auth.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private AccountActivationTokenRepository activationTokenRepository;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${frontend.domain}")
    private String frontendDomain;

    public UserResponse create(UserCreationRequest request) {
        //Create User
        if(userRepository.existsByUsername(request.getUsername()))
            throw new ApiException(ErrorCode.USER_EXISTED);

        User user = userMapper.toUser(request);

        user.setPassword(passwordEncoder.encode(request.getPassword()));
        var role = roleRepository.findByRole("USER").orElseThrow();
        user.setRole(role);
        User finalUser =userRepository.save(user);
        //Send Mail
        String token = UUID.randomUUID().toString();
        AccountActivationToken activationToken =  AccountActivationToken.builder()
                .token(token)
                .user(user)
                .expiryDate(Instant.now().plusSeconds(600))
                .build();
        activationTokenRepository.save(activationToken);
        String subject = "Account Activation";

        String content = String.format("""
        <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6;">
                <h2 style="color: #2E86C1;">Hello %s,</h2>
                <p>Thank you for registering with us.</p>
                <p>Please click the button below to activate your account:</p>
                <a href="%s/account-activation?token=%s"
                   style="display: inline-block; padding: 10px 20px; background-color: #28a745;
                          color: white; text-decoration: none; border-radius: 5px;">
                    Activate Account
                </a>
                <p>This link will expire in <strong>10 minutes</strong>.</p>
                <p>If you didn’t request this, please ignore this email.</p>
                <hr />
                <p style="font-size: 0.9em; color: #888;">&copy; 2025 FitMat3 Company. All rights reserved.</p>
            </body>
        </html>
        """, user.getUsername(), frontendDomain, token);
        System.out.println(finalUser.getEmail());
        emailService.sendHtml(finalUser.getEmail(), subject, content);

        return userMapper.toUserResponse(finalUser);
    }

    public void activateAccount(String token) throws ApiException {
        AccountActivationToken userToken = activationTokenRepository.findByToken(token).orElseThrow(
                ()-> new ApiException(ErrorCode.TOKEN_INVALID)
        );

        User user = userToken.getUser();
        user.setActive(true);
        userRepository.save(user);
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public List<UserResponse> getAll() {
        return userRepository.findAll().stream()
                .map(userMapper::toUserResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS') or #userId == authentication.principal.id")
    public User getById(String userId) {
        return userRepository.findById(userId).orElseThrow(()-> new ApiException(ErrorCode.USER_EXISTED));
    }
    @PreAuthorize("hasAuthority('MANAGE_USERS') or #username == authentication.principal.username")
    public User getByUsername(String username) {
        return userRepository.findByUsername(username).orElseThrow(()-> new ApiException(ErrorCode.USER_NOT_FOUND));
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public User getByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(()-> new ApiException(ErrorCode.USER_NOT_FOUND));
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS') or #userId == authentication.principal.id")
    public User update(String userId ,UserUpdateRequest userUpdateRequest) {
        User user = getById(userId);
        if (userUpdateRequest.getPassword() != null) {
            userUpdateRequest.setPassword(passwordEncoder.encode(userUpdateRequest.getPassword()));
        }
        userMapper.updateUser(user, userUpdateRequest);
        return userRepository.save(user);
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public void delete(String userId) {
        userRepository.deleteById(userId);
    }
}
