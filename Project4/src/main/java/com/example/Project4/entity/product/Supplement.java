package com.example.Project4.entity.product;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Supplement {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer size;

    private String ingredient;

    @OneToOne
    private Product product;

    @ManyToMany
    @JoinTable(
            name = "supplement_scategory",
            joinColumns = @JoinColumn(name = "supplement_id"),
            inverseJoinColumns = @JoinColumn( name = "scategory_id")
    )
    private List<SCategory> scategories;
}
