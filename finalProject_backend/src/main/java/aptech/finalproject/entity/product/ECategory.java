package aptech.finalproject.entity.product;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

import aptech.finalproject.entity.auth.FileMetadata;

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
    @JsonIgnore
    private List<Equipment> equipment;
}
