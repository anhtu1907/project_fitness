package aptech.finalproject.dto.request.product;

import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SupplierRequest {

//    @NotBlank(message = "Supplier type is required") // removed
//    private String type;

    @NotBlank(message = "Supplier name is required")
    private String name;

    @NotBlank(message = "Contact info is required")
    private String contact;

    @NotBlank(message = "Address is required")
    private String address;

    private MultipartFile image;
}
