package com.example.Project4.entity.product;

import com.example.Project4.entity.auth.FileMetadata;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Product {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;

    private Double price;

    private Integer stock;

    private Float rating;

    @OneToOne( cascade = { CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "image_id")
    private FileMetadata image;

    @ManyToOne( cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "supplier_id")
    private Supplier supplier;

    @ManyToOne( cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "promotion_id")
    private Promotion promotion;

    @OneToOne( mappedBy = "product", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "equipment_id")
    private Equipment equipment;

    @OneToOne(mappedBy = "product", cascade = { CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "supplement_id")
    private Supplement supplement;
}
