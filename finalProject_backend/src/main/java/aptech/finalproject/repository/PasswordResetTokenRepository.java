package aptech.finalproject.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.auth.PasswordResetToken;
import aptech.finalproject.entity.auth.User;

import java.util.Optional;

@Repository
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {

    PasswordResetToken findByUserAndUsed(User user, boolean used);

    Optional<PasswordResetToken> findByToken(String token);
}
