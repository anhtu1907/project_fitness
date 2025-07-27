package aptech.finalproject.entity.bmi;

import java.time.LocalDateTime;

import aptech.finalproject.entity.auth.User;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "healths")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PersonHealModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;
    private double height;
    private double weight;
    private double bmi;
    @Column(name = "created_at")
    private LocalDateTime createdAt;

}
