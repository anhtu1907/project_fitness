package aptech.finalproject.entity.product;

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
public class PaymentMethod {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;

    @OneToOne
    @JoinColumn( name = "image_id")
    private FileMetadata image;

    @OneToMany( mappedBy = "paymentMethod", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<Payment> payments;
}
