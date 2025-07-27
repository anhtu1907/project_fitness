package aptech.finalproject.dto.request.product;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ECategoryRequest {

    @NotBlank(message = "Name must not be blank")
    @Size(max = 100, message = "Name must not exceed 100 characters")
    private String name;

    private MultipartFile image;

    @Size(max = 500, message = "Description must not exceed 500 characters")
    private String description;

    private List<Long> equipmentIds;
}
