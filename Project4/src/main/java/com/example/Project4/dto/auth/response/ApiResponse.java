package com.example.Project4.dto.auth.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;
import org.springframework.validation.BindingResult;

import java.util.Map;
import java.util.stream.Collectors;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    @Builder.Default
    private boolean success = true;

    @Builder.Default
    private int code = 400;

    private String message;

    private Map<String, String> errors;

    private T data;

    public static <T> ApiResponse<T> ok() {
        return ApiResponse.<T>builder()
                .success(true)
                .code(200)
                .message("OK")
                .build();
    }

    public static <T> ApiResponse<T> ok(T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .code(200)
                .message("OK")
                .data(data)
                .build();
    }

    public static <T> ApiResponse<T> ok(T data, String message) {
        return ApiResponse.<T>builder()
                .success(true)
                .code(200)
                .message(message)
                .data(data)
                .build();
    }

    public static <T> ApiResponse<T> created(T data, String message) {
        return ApiResponse.<T>builder()
                .success(true)
                .code(201)
                .message(message)
                .data(data)
                .build();
    }

    public static <T> ApiResponse<T> noContent(String message) {
        return ApiResponse.<T>builder()
                .success(true)
                .code(204)
                .message(message)
                .build();
    }

    public static <T> ApiResponse<T> badRequest(String message) {
        return ApiResponse.<T>builder()
                .success(false)
                .code(400)
                .message(message)
                .build();
    }

    public static <T>ApiResponse<T> badRequest(BindingResult bindingResult) {
        Map<String, String> fieldErrors = bindingResult.getFieldErrors().stream()
                .collect(Collectors.toMap(
                        error -> error.getField(),
                        error -> error.getDefaultMessage(),
                        (existing, replacement) -> existing
                ));

        return ApiResponse.<T>builder()
                .success(false)
                .code(400)
                .message("Field validation errors")
                .errors(fieldErrors)
                .build();
    }
    public static <T> ApiResponse<T> notFound(String message) {
        return ApiResponse.<T>builder()
                .success(false)
                .code(404)
                .message(message)
                .build();
    }

    public static <T> ApiResponse<T> serverError(String message) {
        return ApiResponse.<T>builder()
                .success(false)
                .code(500)
                .message(message)
                .build();
    }

    public static <T> ApiResponse<T> error(String message, int code) {
        return ApiResponse.<T>builder()
                .success(false)
                .code(code)
                .message(message)
                .build();
    }
}