package aptech.finalproject.dto.productV2;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SupplierDTO {
    private Long id;
    private String image;
    private String name;
    private String contact;
    private String address;
}
