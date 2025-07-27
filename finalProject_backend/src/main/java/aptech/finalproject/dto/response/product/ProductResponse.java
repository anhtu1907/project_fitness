package aptech.finalproject.dto.response.product;


import aptech.finalproject.dto.product.ProductPromotionDTO;
import lombok.*;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ProductResponse {
    private Long id;

    private String name;

    private String description;

    private Double price;

    private Integer stock;

    private Float rating;

    private String image;

    private String type; // added

    private Long supplier;

    private List<ProductPromotionDTO> promotions;

    private Long equipment;

    private Long supplement;
}
