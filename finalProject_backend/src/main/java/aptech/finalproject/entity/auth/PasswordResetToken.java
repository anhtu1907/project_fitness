package aptech.finalproject.entity.auth;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PasswordResetToken {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String token;

    private Instant expiryDate;

    @CreationTimestamp
    @Column(updatable = false)
    private Instant createdAt;

    @ManyToOne
    private User user;

    @Builder.Default
    private boolean used = false;
}
