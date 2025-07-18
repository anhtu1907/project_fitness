package com.example.Project4.entity.product;

import com.example.Project4.entity.auth.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Order {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private Instant orderDate;

    private Integer totalAmount;

    private Boolean status;

    @ManyToOne
    @JoinColumn( name = "user_id")
    private User user;

    @OneToOne( cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "payment_id")
    private Payment payment;
}
