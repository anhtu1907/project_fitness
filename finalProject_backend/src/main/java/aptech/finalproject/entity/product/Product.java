package aptech.finalproject.entity.product;

import aptech.finalproject.entity.auth.FileMetadata;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    @Column(length = 1000) // to allow longer descriptions
    private String description;

    private Double price;

    private Integer stock;

    private Float rating;

    private String type; // added - equipment | supplement |...


    @OneToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "image_id")
    private FileMetadata image;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "supplier_id")
    private Supplier supplier;

    @OneToOne(mappedBy = "product", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JsonIgnore
    private Equipment equipment;

    @OneToOne(mappedBy = "product", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JsonIgnore
    private Supplement supplement;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
            name = "product_category",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private List<Category> category;

    @OneToMany(mappedBy = "product")
    @JsonIgnore
    private List<OrderDetail> orderDetails;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProductPromotion> productPromotions;
}
