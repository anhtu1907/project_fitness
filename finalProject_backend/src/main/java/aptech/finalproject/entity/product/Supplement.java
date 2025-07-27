package aptech.finalproject.entity.product;

import com.fasterxml.jackson.annotation.JsonManagedReference;
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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer size;

    private String ingredient;

    @OneToOne
    @JoinColumn(name = "product_id")
    @JsonManagedReference
    private Product product;

    @ManyToMany
    @JoinTable(
            name = "supplement_scategory",
            joinColumns = @JoinColumn(name = "supplement_id"),
            inverseJoinColumns = @JoinColumn(name = "scategory_id")
    )
    private List<SCategory> scategories;
}
