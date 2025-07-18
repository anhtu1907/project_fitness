package com.example.Project4.entity.product;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.List;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Promotion {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private Float discount;

    private Instant startDate;

    private Instant endDate;

    @OneToMany( mappedBy = "promotion")
    private List<Product> products;
}
