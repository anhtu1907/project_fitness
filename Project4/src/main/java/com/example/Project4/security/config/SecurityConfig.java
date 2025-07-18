package com.example.Project4.security.config;

import com.example.Project4.dto.auth.response.*;
import com.example.Project4.exception.*;
import com.example.Project4.security.jwt.CustomAuthenticationEntryPoint;
import com.example.Project4.security.jwt.JwtToUserAuthenticationConverter;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;

import javax.crypto.spec.SecretKeySpec;
import java.util.Map;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@EnableScheduling
public class SecurityConfig {

        @Value("${jwt.signerKey}")
        private String SIGNER_KEY;

        @Autowired
        private CustomAuthenticationEntryPoint customAuthenticationEntryPoint;

        // Danh sách route có thể truy cập không cần xác thực hoặc quyền
        private final String[] WHITELIST = {
                        "/auth/**",
                        "/resources/**",
        };

        // Danh sách route tạm thời ngưng truy cập
        private final String[] BLACKLIST = {};
        // Danh sách route IDENTITY được truy cập không cần xác thực hoặc quyền
        private final String[] IDENTITY_WHITELIST = {
                        "/identity/user/create",
        };
        // Danh sách route public
        private final String[] PUBLIC_ENDPOINT = { "/public/**" };

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http, ObjectMapper objectMapper) throws Exception {
                http
                                .csrf(AbstractHttpConfigurer::disable)
                                .authorizeHttpRequests(
                                                request -> request
                                                                .requestMatchers(WHITELIST).permitAll()
                                                                .requestMatchers(IDENTITY_WHITELIST).permitAll()
                                                                .requestMatchers(PUBLIC_ENDPOINT).permitAll()
                                                                .anyRequest().authenticated())
                                .oauth2ResourceServer(oauth2 -> oauth2
                                                .jwt(jwt -> jwt.jwtAuthenticationConverter(
                                                                new JwtToUserAuthenticationConverter()))
                                                .authenticationEntryPoint(customAuthenticationEntryPoint))
                                .exceptionHandling(exception -> exception
                                                .accessDeniedHandler((request, response, accessDeniedException) -> {
                                                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                                                        response.setContentType("application/json");
                                                        ApiResponse<?> apiResponse = ApiResponse.builder()
                                                                        .success(false)
                                                                        .code(ErrorCode.UNAUTHORIZED.getCode())
                                                                        .errors(Map.of("Exception",
                                                                                        "Access Denied by Security Filter"))
                                                                        .build();
                                                        response.getWriter().write(
                                                                        objectMapper.writeValueAsString(apiResponse));
                                                        response.flushBuffer();

                                                })
                                                .authenticationEntryPoint(customAuthenticationEntryPoint));

                return http.build();
        }

        @Bean
        public JwtDecoder jwtDecoder() {
                SecretKeySpec secretKeySpec = new SecretKeySpec(SIGNER_KEY.getBytes(), "HS512");
                return NimbusJwtDecoder
                                .withSecretKey(secretKeySpec)
                                .macAlgorithm(MacAlgorithm.HS512)
                                .build();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder(10);
        }

}
