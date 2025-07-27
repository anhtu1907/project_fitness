package aptech.finalproject.payload.meal;


import java.time.LocalDateTime;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserMealsRequest {
    private String user;
    private List<Integer> meal;
    private LocalDateTime created;
}
