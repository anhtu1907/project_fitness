package aptech.finalproject.repository;

import aptech.finalproject.emums.DeviceType;
import aptech.finalproject.entity.auth.Token;
import aptech.finalproject.entity.auth.User;
import jakarta.validation.constraints.Size;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Repository
public interface TokenRepository extends JpaRepository<Token, String> {

    Optional<Token> findByRefreshToken(String refreshToken);

    List<Token> findByUserUsernameAndDeviceTypeAndRevoked(@Size(min = 3, max = 30, message = "USERNAME_INVALID") String userUsername, DeviceType deviceType, boolean revoked);

    @Query("SELECT COUNT(DISTINCT t.user.id) FROM Token t WHERE t.issuedAt >= :from AND t.revoked = false")
    long countDistinctUserActiveSince(@Param("from") Instant from);
}
