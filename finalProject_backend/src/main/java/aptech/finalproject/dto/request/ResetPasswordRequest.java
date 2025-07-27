package aptech.finalproject.dto.request;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ResetPasswordRequest {
    private String token;
    private String password;
}
