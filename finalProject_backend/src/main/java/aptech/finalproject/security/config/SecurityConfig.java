package aptech.finalproject.security.config;

import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.security.jwt.CustomAuthenticationEntryPoint;
import aptech.finalproject.security.jwt.JwtToUserAuthenticationConverter;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.Customizer;
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
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import javax.crypto.spec.SecretKeySpec;
import java.util.List;
import java.util.Map;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@Slf4j
public class SecurityConfig {

        @Value("${jwt.signerKey}")
        private String SIGNER_KEY;

        @Autowired
        private CustomAuthenticationEntryPoint customAuthenticationEntryPoint;

        // Danh sách route có thể truy cập không cần xác thực hoặc quyền
        private final String[] WHITELIST = {
                        "/auth/**",
                        "/resources/**",
                        "/api/productV2/**",
                        "/api/promotion",
                        "/api/exercise/**",
                        "/api/meal/**",
                        "/identity/user/**",
        };

        // Danh sách route tạm thời ngưng truy cập
        private final String[] BLACKLIST = {};
        // Danh sách route IDENTITY được truy cập không cần xác thực hoặc quyền
        private final String[] IDENTITY_WHITELIST = {
                        "/identity/user/**",
        };

        // Danh sách route public
        private final String[] PUBLIC_ENDPOINT = { "/public/**" };

        @Bean
        @Order(2) // Lower priority = used for everything except PayPal
        public SecurityFilterChain jwtSecurityFilterChain(HttpSecurity http, ObjectMapper objectMapper)
                        throws Exception {
                http
                                .csrf(AbstractHttpConfigurer::disable)
                                .cors(Customizer.withDefaults())
                                .authorizeHttpRequests(request -> request
                                                .requestMatchers(WHITELIST).permitAll()
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
        @Order(1) // Higher priority = used for PayPal routes
        public SecurityFilterChain paypalFilterChain(HttpSecurity http) throws Exception {
                http
                                .securityMatcher("/api/payment/paypal/**") // chỉ áp dụng cho route PayPal
                                .csrf(AbstractHttpConfigurer::disable)
                                .authorizeHttpRequests(auth -> auth.anyRequest().permitAll()); // ✅ Bỏ qua xác thực JWT
                return http.build();
        }

        // ================== 🔐 JWT DECODER ==================
        @Bean
        public JwtDecoder jwtDecoder() {
                SecretKeySpec secretKeySpec = new SecretKeySpec(SIGNER_KEY.getBytes(), "HS512");
                return NimbusJwtDecoder
                                .withSecretKey(secretKeySpec)
                                .macAlgorithm(MacAlgorithm.HS512)
                                .build();
        }

        // ================== 🔐 PASSWORD ENCODER ==================
        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder(10);
        }

        // ================== 🔐 CORS ==================
        @Bean
        public CorsConfigurationSource corsConfigurationSource() {
                CorsConfiguration configuration = new CorsConfiguration();
                configuration.setAllowedOrigins(List.of("http://localhost:5173", "http://localhost:3000"));
                configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
                configuration.setAllowedHeaders(List.of("*"));
                configuration.setAllowCredentials(true);

                UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
                source.registerCorsConfiguration("/**", configuration);
                return source;
        }
}