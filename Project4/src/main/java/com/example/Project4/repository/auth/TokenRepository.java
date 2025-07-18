package com.example.Project4.repository.auth;

import com.example.Project4.emums.*;
import com.example.Project4.entity.auth.*;
import jakarta.validation.constraints.Size;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TokenRepository extends JpaRepository<Token, String> {

    Optional<Token> findByRefreshToken(String refreshToken);

    List<Token> findByUserUsernameAndDeviceTypeAndRevoked(@Size(min = 3, max = 30, message = "USERNAME_INVALID") String userUsername, DeviceType deviceType, boolean revoked);
}
