package aptech.finalproject.dto.auth;

import java.time.LocalDate;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {
    private String id;
    private String username;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private int gender;
    private String address;
    private boolean active;
    private LocalDate dob;
}
