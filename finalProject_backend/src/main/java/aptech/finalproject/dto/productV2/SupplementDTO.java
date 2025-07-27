package aptech.finalproject.dto.productV2;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class SupplementDTO {
    private Long id;

    private Integer size;

    private String ingredient;

    private List<String> categoryNames;

    private ProductDTO product;

    private PromotionDTO promotion;

    private SupplierDTO supplier;
}
