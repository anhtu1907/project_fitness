package aptech.finalproject.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = PromotionDatesValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidPromotionDates {
    String message() default "End date must be at least 1 day after start date";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
