package aptech.finalproject.service;

import aptech.finalproject.dto.request.UserCreationRequest;
import aptech.finalproject.dto.request.UserUpdateRequest;
import aptech.finalproject.dto.response.UserResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.exception.ApiException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Map;

public interface UserService {
    UserResponse create(UserCreationRequest request);

    void activateAccount(String token) throws ApiException;

    Page<UserResponse> getAll(Pageable pageable);

    User getById(String userId);

    User getByUsername(String username);

    User getByEmail(String email);

    User update(String userId , UserUpdateRequest userUpdateRequest);

    void delete(String userId);

    Page<UserResponse> searchUsersByName(String keyword, Pageable pageable);

    Map<String, Long> getUserStatistics();

    Page<UserResponse> getInactiveUsers(Pageable pageable);
}
