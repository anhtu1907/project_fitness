package aptech.finalproject.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.auth.AccountActivationToken;

import java.util.Optional;

@Repository
public interface AccountActivationTokenRepository extends JpaRepository<AccountActivationToken, Long> {
    Optional<AccountActivationToken> findByToken(String token);
}
