package aptech.finalproject.entity.product;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Payment {
    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    private String transactionCode;

    private Instant paymentDate;

    private Integer amount;

    private Boolean status;

    private String currency;

    @OneToOne
    private Order order;

    @ManyToOne
    @JoinColumn( name = "payment_method_id")
    private PaymentMethod paymentMethod;
}
