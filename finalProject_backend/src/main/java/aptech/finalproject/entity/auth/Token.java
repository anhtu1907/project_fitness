package aptech.finalproject.entity.auth;

import aptech.finalproject.emums.DeviceType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

@Entity
@Table(name = "tokens")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Token {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false, unique = true, length = 255)
    private String refreshToken;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private DeviceType deviceType;

    @Column(length = 500)
    private String userAgent;

    @Column(length = 45)
    private String ipAddress;

    @CreationTimestamp
    @Column(updatable = false)
    private Instant issuedAt;

    private Instant expiresAt;

    private boolean revoked;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn( name = "user_id", nullable = false)
    private User user;
}
