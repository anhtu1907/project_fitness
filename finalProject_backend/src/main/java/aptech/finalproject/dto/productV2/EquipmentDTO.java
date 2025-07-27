package aptech.finalproject.dto.productV2;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
public class EquipmentDTO {
    private Long id;

    private Integer size;

    private String color;

    private String gender;

    private List<String> categoryNames;

    private ProductDTO product;

    private PromotionDTO promotion;

    private SupplierDTO supplier;
}
