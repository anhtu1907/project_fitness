package aptech.finalproject.controller.auth;

import aptech.finalproject.dto.request.UserCreationRequest;
import aptech.finalproject.dto.request.UserUpdateRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.UserResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.UserMapper;
import aptech.finalproject.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Map;

@RestController
@RequestMapping("/identity/user")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private UserMapper userMapper;

    @Value("${frontend.domain}")
    private String frontendDomain;

    @PostMapping("/create")
    public ApiResponse<UserResponse> create(@RequestBody @Valid UserCreationRequest userCreationRequest,
                                            BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        UserResponse user = userService.create(userCreationRequest);
        if (user == null) {
            return ApiResponse.badRequest(ErrorCode.USER_CREATION_FAILED.getException());
        }
        return ApiResponse.created(user, "Created user");
    }

    @GetMapping("/activation")
    public RedirectView activateAccount(@RequestParam("token") String token) {
        userService.activateAccount(token);
        return new RedirectView(frontendDomain + "/account-activation-success");
    }

    @GetMapping()
    public ApiResponse<Page<UserResponse>> getAll(Pageable pageable) {
        Page<UserResponse> users = userService.getAll(pageable);
        if(users.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(users, "Get all users");
    }

    @GetMapping("/id/{userId}")
    public ApiResponse<UserResponse> getById(@PathVariable String userId) {
        User user = userService.getById(userId);
        if(user == null) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(userMapper.toUserResponse(user), "Get user by id");
    }

    @GetMapping("/username/{username}")
    public ApiResponse<UserResponse> getByUsername(@PathVariable String username) {
        User user = userService.getByUsername(username);
        if(user == null){
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(userMapper.toUserResponse(user), "Get user by username");
    }

    @PutMapping("/{userId}")
    public ApiResponse<UserResponse> update(@PathVariable String userId,
                                            @RequestBody @Valid UserUpdateRequest userUpdateRequest,
                                            BindingResult result) {
        if(result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        User updated = userService.update(userId, userUpdateRequest);

        if (updated == null) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(userMapper.toUserResponse(updated), "Update user");
    }

    @DeleteMapping("/{userId}")
    public ApiResponse<UserResponse> delete(@PathVariable String userId){
        userService.delete(userId);
        return ApiResponse.noContent(String.format("Deleted user with id %s", userId));
    }

    @GetMapping("/search")
    public ApiResponse<Page<UserResponse>> searchUsers(
            @RequestParam("keyword") String keyword,
            Pageable pageable
    ) {
        Page<UserResponse> users = userService.searchUsersByName(keyword, pageable);
        if (users.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(users, "Search users by name");
    }

    @GetMapping("/statistics")
    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public ApiResponse<Map<String, Long>> getUserStatistics() {
        Map<String, Long> stats = userService.getUserStatistics();
        return ApiResponse.ok(stats, "User statistics");
    }

    @GetMapping("/inactive")
    @PreAuthorize("hasAuthority('MANAGE_USERS')")
    public ApiResponse<Page<UserResponse>> getInactiveUsers(Pageable pageable) {
        Page<UserResponse> inactiveUsers = userService.getInactiveUsers(pageable);
        if (inactiveUsers.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(inactiveUsers, "Get inactive users");
    }
}
