package aptech.finalproject.dto.response.product;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryResponse {
    private Long id;

    private String name;

    private String description;
}
