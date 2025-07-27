package aptech.finalproject.dto.productV2;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductCardDTO {
    private Long id; // productId
    private String name;
    private String image;
    private Double price;
    private Float rating;
    private Integer stock;
    private Float discount; // get from promotion
    private String type; // equipment or supplement
    private Long detailId; // get from equipment or supplement
    private List<Long> categoryIds;
}