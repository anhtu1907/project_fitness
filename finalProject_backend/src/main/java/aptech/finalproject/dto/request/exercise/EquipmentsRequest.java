package aptech.finalproject.dto.request.exercise;

import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class EquipmentsRequest {
    @NotBlank(message = "Equipment name must not be blank")
    private String equipmentName;

    private MultipartFile equipmentImage;
}
