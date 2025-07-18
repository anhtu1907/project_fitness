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
public class ECategory {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToOne( cascade = {CascadeType.PERSIST, CascadeType.MERGE} )
    @JoinColumn( name = "image_id")
    private FileMetadata image;

    private String description;

    @ManyToMany
    private List<Equipment> equipment;
}
