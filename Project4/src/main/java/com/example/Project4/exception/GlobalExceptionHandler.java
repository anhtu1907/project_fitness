package com.example.Project4.exception;

import com.example.Project4.dto.auth.response.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = RuntimeException.class)
    ResponseEntity<ApiResponse<String>> handleRuntimeException(RuntimeException e) {
        Map<String, String> error = new HashMap<>();
        error.put("Exception", e.getMessage());
        ApiResponse<String> apiResponse = ApiResponse.<String>builder()
                .success(false)
                .code(400)
                .errors(error)
                .build();
        return ResponseEntity.badRequest().body(apiResponse);
    }

    @ExceptionHandler(value = ApiException.class)
    ResponseEntity<ApiResponse<String>> handleApiException(ApiException e) {
        Map<String, String> error = new HashMap<>();
        error.put("Exception", e.getErrorCode().getException());
        ApiResponse<String> apiResponse = ApiResponse.<String>builder()
                .success(false)
                .code(e.getErrorCode().getCode())
                .errors(error)
                .build();
        return ResponseEntity.badRequest().body(apiResponse);
    }



    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    ResponseEntity<ApiResponse<String>> handlingValidationException(MethodArgumentNotValidException e) {
        String key  = e.getFieldError().getDefaultMessage();
        ErrorCode errorCode = ErrorCode.KEYWORD_INVALID;
        try {
            errorCode = ErrorCode.valueOf(key);
        }catch (IllegalArgumentException illegalArgumentException) {
            illegalArgumentException.printStackTrace();
        }
        Map<String, String> error = new HashMap<>();
        error.put("Error", errorCode.getException());
        ApiResponse<String> apiResponse = new ApiResponse<>();
        apiResponse.setCode(errorCode.getCode());
        apiResponse.setErrors(error);
        return ResponseEntity.badRequest().body(apiResponse);
    }
}
