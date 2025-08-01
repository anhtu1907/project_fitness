package aptech.finalproject.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserUpdateRequest {

    private String password;

    private String firstName;

    private String lastName;

    private String email;

    private String phone;

    private String address;

    private String roleName;

    private LocalDate dob;

    private boolean active;
}
