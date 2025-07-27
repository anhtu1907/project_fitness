package aptech.finalproject.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserCreationRequest {

    @NotBlank(message = "Username is required!")
    @Size(min = 5, message = "Username must be at least 5 characters long!")
    private String username;

    @NotBlank(message = "Password is required!")
    @Size(min = 6, max = 100, message = "Password must be between 6 and 100 characters!")
    private String password;

    @NotBlank(message = "First name is required!")
    @Size(max = 50, message = "First name must be less than 50 characters!")
    private String firstName;

    @NotBlank(message = "Last name is required!")
    @Size(max = 50, message = "Last name must be less than 50 characters!")
    private String lastName;

    @NotBlank(message = "Email is required!")
    @Email(message = "Email format is invalid!")
    private String email;

    @NotBlank(message = "Phone number is required!")
    @Pattern(regexp = "^\\+?[0-9]{10,15}$", message = "Phone number must be valid and contain 10 to 15 digits!")
    private String phone;

    @NotBlank(message = "Address is required!")
    @Size(max = 200, message = "Address must be less than 200 characters!")
    private String address;
    
    @NotNull(message = "Gender is required!")
    private int gender;

    @NotNull(message = "Date of birth is required!")
    @Past(message = "Date of birth must be in the past!")
    private LocalDate dob;

}

