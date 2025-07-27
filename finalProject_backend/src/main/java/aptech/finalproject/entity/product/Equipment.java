package aptech.finalproject.entity.product;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
    private List<ECategory> ecategories;

    @OneToOne
    @JsonIgnore
    private Product product;
}
