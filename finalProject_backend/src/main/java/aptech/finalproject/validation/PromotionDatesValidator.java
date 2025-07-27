package aptech.finalproject.validation;

import aptech.finalproject.dto.request.product.PromotionRequest;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;

public class PromotionDatesValidator implements ConstraintValidator<ValidPromotionDates, PromotionRequest> {

    @Override
    public boolean isValid(PromotionRequest request, ConstraintValidatorContext context) {
        Instant start = request.getStartDate();
        Instant end = request.getEndDate();

        if (start == null || end == null) {
            return true; //
        }

        LocalDate startDate = start.atZone(ZoneOffset.UTC).toLocalDate();
        LocalDate endDate = end.atZone(ZoneOffset.UTC).toLocalDate();
        LocalDate today = Instant.now().atZone(ZoneOffset.UTC).toLocalDate();

        boolean isValid = true;
        context.disableDefaultConstraintViolation();

        if (startDate.isBefore(today)) {
            context.buildConstraintViolationWithTemplate("Start date must not be in the past")
                    .addPropertyNode("startDate")
                    .addConstraintViolation();
            isValid = false;
        }

        if (endDate.isBefore(today)) {
            context.buildConstraintViolationWithTemplate("End date must not be in the past")
                    .addPropertyNode("endDate")
                    .addConstraintViolation();
            isValid = false;
        }

        if (!endDate.isAfter(startDate)) {
            context.buildConstraintViolationWithTemplate("End date must be after start date")
                    .addPropertyNode("endDate")
                    .addConstraintViolation();
            isValid = false;
        }

        return isValid;
    }
}
