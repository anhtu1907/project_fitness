package aptech.finalproject.service;

import aptech.finalproject.dto.request.UserCreationRequest;
import aptech.finalproject.dto.request.UserUpdateRequest;
import aptech.finalproject.dto.response.UserResponse;
import aptech.finalproject.entity.auth.AccountActivationToken;
import aptech.finalproject.entity.auth.Role;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.UserMapper;
import aptech.finalproject.repository.AccountActivationTokenRepository;
import aptech.finalproject.repository.RoleRepository;
import aptech.finalproject.repository.TokenRepository;
import aptech.finalproject.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
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
    private TokenRepository tokenRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${frontend.domain}")
    private String frontendDomain;

    @Value("${app.backend-url}")
    private String backendUrl;

    public UserResponse create(UserCreationRequest request) {
        // Create User
        if (userRepository.existsByUsername(request.getUsername()))
            throw new ApiException(ErrorCode.USER_EXISTED);

        User user = userMapper.toUser(request);

        user.setPassword(passwordEncoder.encode(request.getPassword()));
        var role = roleRepository.findByRole("USER").orElseThrow();
        user.setRole(role);
        User finalUser = userRepository.save(user);
        // Send Mail
        String token = UUID.randomUUID().toString();
        AccountActivationToken activationToken = AccountActivationToken.builder()
                .token(token)
                .user(user)
                .expiryDate(Instant.now().plusSeconds(600))
                .build();
        activationTokenRepository.save(activationToken);
        String subject = "Account Activation";
        String username = user.getUsername();
        String activationLink = backendUrl + "/identity/user/activation?token=" + token;

        String content = String.format("""
                <html>
                    <body style="font-family: Arial, sans-serif; line-height: 1.6;">
                        <h2 style="color: #2E86C1;">Hello %s,</h2>
                        <p>Thank you for registering with us.</p>
                        <p>Please click the button below to activate your account:</p>
                        <a href="%s"
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
                """, username, activationLink);
        System.out.println(content);
        emailService.sendHtml(finalUser.getEmail(), subject, content);

        return userMapper.toUserResponse(finalUser);
    }

    public void activateAccount(String token) throws ApiException {
        AccountActivationToken userToken = activationTokenRepository.findByToken(token).orElseThrow(
                () -> new ApiException(ErrorCode.TOKEN_INVALID));

        User user = userToken.getUser();
        user.setActive(true);
        userRepository.save(user);
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public Page<UserResponse> getAll(Pageable pageable) {
        return userRepository.findAll(pageable)
                .map(userMapper::toUserResponse);
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS') or #userId == authentication.principal.id")
    public User getById(String userId) {
        return userRepository.findById(userId).orElseThrow(() -> new ApiException(ErrorCode.USER_EXISTED));
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS') or #username == authentication.principal.username")
    public User getByUsername(String username) {
        return userRepository.findByUsername(username).orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public User getByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS') or #userId == authentication.principal.id")
    public User update(String userId, UserUpdateRequest request) {
        User user = getById(userId);

        if (request.getFirstName() != null) {
            user.setFirstName(request.getFirstName());
        }

        if (request.getLastName() != null) {
            user.setLastName(request.getLastName());
        }

        if (request.getEmail() != null) {
            user.setEmail(request.getEmail());
        }

        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }

        if (request.getAddress() != null) {
            user.setAddress(request.getAddress());
        }

        if (request.getDob() != null) {
            user.setDob(request.getDob());
        }

        if (request.getRoleName() != null) {
            Role role = roleRepository.findByRole(request.getRoleName())
                    .orElseThrow(() -> new ApiException(ErrorCode.ROLE_NOT_FOUND));
            user.setRole(role);
        }

        if (request.getPassword() != null) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }
        if (request.isActive() != user.isActive()) {
            user.setActive(request.isActive());
        }

        return userRepository.save(user);
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public void delete(String userId) {
        userRepository.deleteById(userId);
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public Page<UserResponse> searchUsersByName(String keyword, Pageable pageable) {
        return userRepository
                .findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(keyword, keyword, pageable)
                .map(userMapper::toUserResponse);
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public Map<String, Long> getUserStatistics() {
        long totalUsers = userRepository.count();
        long activeUsers = userRepository.countByActive(true);
        long inactiveUsers = totalUsers - activeUsers;

        Instant sevenDaysAgo = Instant.now().minus(7, ChronoUnit.DAYS);
        long weeklyActiveUsers = tokenRepository.countDistinctUserActiveSince(sevenDaysAgo);

        Map<String, Long> stats = new HashMap<>();
        stats.put("totalUsers", totalUsers);
        stats.put("activeUsers", activeUsers);
        stats.put("inactiveUsers", inactiveUsers);
        stats.put("weeklyActiveUsers", weeklyActiveUsers);

        return stats;
    }

    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public Page<UserResponse> getInactiveUsers(Pageable pageable) {
        return userRepository.findByActiveFalse(pageable)
                .map(userMapper::toUserResponse);
    }
}
