package aptech.finalproject.entity.product;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

import aptech.finalproject.entity.auth.FileMetadata;

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

//    private String type; // remove

    private String name;

    private String contact;

    private String address;

    @OneToOne( cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn( name = "image_id")
    private FileMetadata image;

    @OneToMany( mappedBy = "supplier")
    @JsonIgnore
    private List<Product> products;
}
