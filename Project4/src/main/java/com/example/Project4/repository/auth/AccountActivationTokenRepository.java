package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.AccountActivationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AccountActivationTokenRepository extends JpaRepository<AccountActivationToken, Long> {
    Optional<AccountActivationToken> findByToken(String token);
}
