package aptech.finalproject.dto.productV2;

import jakarta.persistence.Column;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProductDTO {
    private Long id;

    private String name;

    private String image;

    private String description;

    private Double price;

    private Integer stock;

    private Float rating;

    private String type;

}
