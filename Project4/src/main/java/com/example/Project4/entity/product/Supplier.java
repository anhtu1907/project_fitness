package com.example.Project4.entity.product;

import com.example.Project4.entity.auth.FileMetadata;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Supplier {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String type;

    private String name;

    private String contact;

    private String address;

    @OneToOne( cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "image_id")
    private FileMetadata image;

    @OneToMany( mappedBy = "supplier")
    private List<Product> products;
}
