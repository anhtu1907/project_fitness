package com.example.Project4.entity.product;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Equipment {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer size;

    private String color;

    private String gender;

    @ManyToMany
    @JoinTable(
            name = "equipment_ecategory",
            joinColumns = @JoinColumn( name = "equipment_id"),
            inverseJoinColumns = @JoinColumn( name = "ecategory_id")
    )
    private List<ECategory> category;

    @OneToOne
    private Product product;

}
