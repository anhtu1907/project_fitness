package aptech.finalproject.dto.bmi;

import lombok.*;
import java.time.LocalDateTime;

import aptech.finalproject.dto.auth.UserDTO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PersonalHealthDTO {
     private int id;
    private UserDTO user;
    private double height;
    private double weight;
    private double bmi;
    private LocalDateTime createdAt;
}
