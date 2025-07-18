package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {

    PasswordResetToken findByUserAndUsed(User user, boolean used);

    Optional<PasswordResetToken> findByToken(String token);
}
