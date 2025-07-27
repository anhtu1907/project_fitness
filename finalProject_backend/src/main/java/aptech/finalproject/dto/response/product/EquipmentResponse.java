package aptech.finalproject.dto.response.product;


import aptech.finalproject.entity.product.Product;
import lombok.*;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EquipmentResponse {
    private Long id;

    private Integer size;

    private String color;

    private String gender;

    private Long productId;

    private List<Long> categoryIds; // change to categoryIds


}
