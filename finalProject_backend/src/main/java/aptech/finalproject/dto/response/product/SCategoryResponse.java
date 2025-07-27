package aptech.finalproject.dto.response.product;


import lombok.*;

import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SCategoryResponse {
    private Long id;

    private String  name;

    private String description;

    private List<Long> supplements;
}
