package aptech.finalproject.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public enum ErrorCode {
    //Authentication and Authorization
        //USER
    USER_UNAUTHORIZED(403, "Unauthorized"),
    USERNAME_OR_PASSWORD_INCORRECT(401, "Username or password incorrect"),
    USER_FORBIDDEN(403, "Forbidden"),
    USER_EXISTED(400, "User existed."),
    USER_NOT_FOUND(404, "User not found."),
    USER_UNAUTHENTICATED(401, "Unauthenticated"),
    USER_CREATION_FAILED(400, "User creation failed"),
    USER_NOT_ACTIVE(403, "User not active"),
        //ROLE
    ROLE_NOT_FOUND(404, "Role not found."),
    ROLE_ALREADY_EXISTED(409, "Role already existed."),
        //PERMISSION
    PERMISSION_NOT_FOUND(404, "Permission not found."),
    PERMISSION_ALREADY_EXISTED(409, "Permission already existed."),
        //TOKEN
    JWT_TOKEN_INVALID(401, "JWT token is invalid"),
    JWT_TOKEN_EXPIRED(401, "JWT token is expired"),
    TOKEN_NOT_FOUND(404, "Token not found."),
    TOKEN_DEVICE_LIMIT_EXCEEDED(409, "Token device limit exceeded."),
    REFRESH_TOKEN_NOT_FOUND(404, "Refresh token not found."),
    REFRESH_TOKEN_EXPIRED(401, "Refresh token expired."),
    REFRESH_TOKEN_INVALID(401, "Refresh token invalid."),
    REFRESH_TOKEN_ALREADY_REVOKED(409, "Refresh token already revoked."),
    UNAUTHORIZED(401, "Unauthorized"),
    FORBIDDEN(403, "Forbidden"),
    TOKEN_INVALID(401, "Invalid token."),

    PASSWORD_RESET_TOKEN_INVALID(401, "The password reset token is invalid."),
    SEND_EMAIL_AFTER_MINUTE(409, "Please wait a few minutes before sending another email."),
        //DEVICE
    INVALID_DEVICE_TYPE(400, "Invalid device type."),
    INVALID_DEVICE_CONTEXT(400, "Invalid device context."),
        //RESET PASSWORD TOKEN
    RESET_PASSWORD_TOKEN_ALREADY_EXISTED(409, "Reset password token already existed."),
    INVALID_RESET_PASSWORD_TOKEN(401, "Invalid reset password token."),
    RESET_PASSWORD_TOKEN_ALREADY_USED(409, "Reset password token used."),
    RESET_PASSWORD_TOKEN_EXPIRED(401, "Reset password token expired."),

    //File management
        //FILE TYPE
    NOT_SUPPORTED_FILE_TYPE(400, "Not supported file type."),
    FILE_IS_EMPTY(400, "File is empty."),
    FILE_NOT_FOUND(404, "File not found."),
    FILE_ALREADY_EXISTED(409, "File already existed."),
    FILE_ALREADY_USED(409, "File already used."),
    FILE_DELETE_FAILED(409, "File delete failed."),
    MIME_TYPE_NOT_FOUND(404, "Mime type not found."),
    FILE_UPLOAD_FAILED(400,"Cannot store file"),
    FILE_READ_FAILED(400, "Failed to load file"),
    FILE_ALREADY_EXISTS(409, "File already exists."),
        //FILE SIZE
    FILE_TOO_LARGE(409 , "File too large."),

    //Database
    DATABASE_ERROR( 400,"Failed to save file metadata"),
    //Validation
    USERNAME_INVALID(400, "Username must be between 3 and 30 characters"),
    PASSWORD_INVALID(400, "Password must be between 3 and 30 characters"),
    KEYWORD_INVALID(400, "Keyword not valid"),

    //Product
    PRODUCT_NOT_FOUND(404, "Product not found."),
    PRODUCT_CREATION_FAILED(409, "Product creation failed."),

    //Supplier
    SUPPLIER_NOT_FOUND(404, "Supplier not found."),

    //Supplement
    SUPPLEMENT_NOT_FOUND(404, "Supplement not found."),

    //SCategory
    SCATEGORY_NOT_FOUND(404, "Scategory not found."),

    //Promotion
    PROMOTION_NOT_FOUND(404, "Promotion not found."),

    //Payment
    PAYMENT_NOT_FOUND(404, "Payment not found."),

    //PaymentMethod
    PAYMENT_METHOD_NOT_FOUND(404, "Payment method not found."),

    //Order
    ORDER_NOT_FOUND(404, "Order not found."),

    //OrderDetail
    ORDER_DETAIL_NOT_FOUND(404, "Order detail not found."),

    //Equipment
    EQUIPMENT_NOT_FOUND(404, "Equipment not found."),

    //ECategory
    ECATEGORY_NOT_FOUND(404, "Category not found."),
    ECATEGORY_CREATION_FAILED(409, "Category creation failed."),

    //Meal
    MEAL_SUBCATEGORY_NOT_FOUND(404, "Meal subcategory not found."),
    MEAL_TIME_NOT_FOUND(404, "Meal time not found."),
    MEAL_NOT_FOUND(404, "Meal not found."),
    MEAL_CATEGORY_NOT_FOUND(404, "Meal category not found."),
    USER_MEAL_NOT_FOUND(404, "User meal not found."),

    //Exercise
    EXERCISE_CATEGORY_NOT_FOUND(404, "Exercise category not found."),
    EXERCISE_NOT_FOUND(404, "Exercise not found."),
    EXERCISE_MODE_NOT_FOUND(404, "Exercise mode not found."),
    EXERCISE_SUBCATEGORY_NOT_FOUND(404, "Exercise subcategory not found."),

    EXERCISE_FAVORITE_NOT_FOUND(404, "Exercise favorite not found."),
    EXERCISE_PROGRAM_NOT_FOUND(404, "Exercise program not found."),
    EXERCISE_PROGRESS_NOT_FOUND(404, "Exercise progress not found."),
    EXERCISE_SCHEDULE_NOT_FOUND(404, "Exercise schedule not found."),
    EXERCISE_SESSION_NOT_FOUND(404, "Exercise session not found."),
    EXERCISE_USER_NOT_FOUND(404, "Exercise user not found."),
    EQUIPMENT_CREATION_FAILED(409, "Equipment creation failed."),
    DATE_VALUE_INVALID(400, "Date value is invalid."),
    BAD_REQUEST(400, "Bad request"),
    ;


    private int code;
    private String exception;

}
