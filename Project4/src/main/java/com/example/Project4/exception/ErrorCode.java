package com.example.Project4.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public enum ErrorCode {
    //Authentication and Authorization
        //USER
    USER_UNAUTHORIZED(401, "Unauthorized"),
    USER_EXISTED(400, "User existed!"),
    USER_NOT_FOUND(404, "User not found!"),
    USER_UNAUTHENTICATED(401, "Unauthenticated"),
    USER_CREATION_FAILED(400, "User creation failed"),
        //ROLE
    ROLE_NOT_FOUND(404, "Role not found!"),
    ROLE_ALREADY_EXISTED(409, "Role already existed!"),
        //PERMISSION
    PERMISSION_NOT_FOUND(404, "Permission not found!"),
    PERMISSION_ALREADY_EXISTED(409, "Permission already existed!"),
        //TOKEN
    JWT_TOKEN_INVALID(401, "JWT token is invalid or expired!"),
    TOKEN_NOT_FOUND(404, "Token not found!"),
    TOKEN_DEVICE_LIMIT_EXCEEDED(409, "Token device limit exceeded!"),
    REFRESH_TOKEN_NOT_FOUND(404, "Refresh token not found!"),
    REFRESH_TOKEN_EXPIRED(409, "Refresh token expired!"),
    REFRESH_TOKEN_INVALID(409, "Refresh token invalid!"),
    REFRESH_TOKEN_ALREADY_REVOKED(409, "Refresh token already revoked!"),
        //DEVICE
    INVALID_DEVICE_TYPE(400, "Invalid device type!"),
    INVALID_DEVICE_CONTEXT(400, "Invalid device context!"),
        //RESET PASSWORD TOKEN
    RESET_PASSWORD_TOKEN_ALREADY_EXISTED(409, "Reset password token already existed!"),
    INVALID_RESET_PASSWORD_TOKEN(409, "Invalid reset password token!"),
    RESET_PASSWORD_TOKEN_ALREADY_USED(409, "Reset password token used!"),
    RESET_PASSWORD_TOKEN_EXPIRED(409, "Reset password token expired!"),

    //File management
        //FILE TYPE
    NOT_SUPPORTED_FILE_TYPE(400, "Not supported file type!"),
    FILE_IS_EMPTY(404, "File is empty!"),
    FILE_NOT_FOUND(404, "File not found!"),
    FILE_ALREADY_EXISTED(409, "File already existed!"),
    FILE_ALREADY_USED(409, "File already used!"),
    FILE_DELETE_FAILED(409, "File delete failed!"),
    MIME_TYPE_NOT_FOUND(404, "Mime type not found!"),

    //Validation
    USERNAME_INVALID(401, "Username must be between 3 and 30 characters"),
    PASSWORD_INVALID(401, "Password must be between 3 and 30 characters"),
    KEYWORD_INVALID(401, "Keyword not valid"),
    ;

    private int code;
    private String exception;

}
