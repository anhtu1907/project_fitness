package com.example.Project4.security.jwt;

import com.example.Project4.dto.auth.response.ApiResponse;
import com.example.Project4.exception.ErrorCode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;

@Component
@Slf4j
@RequiredArgsConstructor
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {
    private final ObjectMapper objectMapper;

    @Override
    public void commence(HttpServletRequest request,
                         HttpServletResponse response,
                         AuthenticationException authException) throws ServletException, IOException {

        String message = authException.getMessage();
        String error = ErrorCode.UNAUTHORIZED.getException();
        int code = ErrorCode.UNAUTHORIZED.getCode();

        if (message != null) {
            if (message.contains("expired")) {
                error = ErrorCode.JWT_TOKEN_EXPIRED.getException();
                code = ErrorCode.JWT_TOKEN_EXPIRED.getCode();
            } else if (message.contains("invalid") || message.contains("Malformed")) {
                error = ErrorCode.JWT_TOKEN_INVALID.getException();
                code = ErrorCode.JWT_TOKEN_INVALID.getCode();
            }
        }

        ApiResponse<?> apiResponse = ApiResponse.builder()
                .success(false)
                .code(code)
                .errors(Map.of("error", error))
                .build();

        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.getWriter().write(objectMapper.writeValueAsString(apiResponse));
    }

}
