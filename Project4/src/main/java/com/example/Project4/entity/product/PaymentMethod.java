package com.example.Project4.entity.product;

import com.example.Project4.entity.auth.FileMetadata;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentMethod {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String description;

    @OneToOne
    @JoinColumn( name = "image_id")
    private FileMetadata image;

    @OneToMany( mappedBy = "paymentMethod", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<Payment> payments;
}
