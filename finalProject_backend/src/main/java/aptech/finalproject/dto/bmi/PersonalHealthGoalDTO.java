package aptech.finalproject.dto.bmi;

import lombok.*;
import java.time.LocalDateTime;

import aptech.finalproject.dto.auth.UserDTO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class PersonalHealthGoalDTO {
    private int id;
    private UserDTO user;
    private double targetWeight;
    private LocalDateTime createdAt;
}
