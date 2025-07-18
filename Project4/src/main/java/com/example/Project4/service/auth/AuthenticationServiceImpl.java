package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.example.Project4.emums.*;
import com.example.Project4.entity.auth.*;
import com.example.Project4.exception.*;
import com.example.Project4.repository.auth.*;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
@Slf4j
public class AuthenticationServiceImpl implements AuthenticationService {
     @Autowired
    UserRepository userRepository;

    @Autowired
    TokenRepository tokenRepository;

    @Autowired
    PasswordEncoder passwordEncoder;

    @Value("${jwt.signerKey}")
    private String SIGNER_KEY;
    @Value("${jwt.expiration}")
    private Long EXPIRATION_TIME;
    @Value("${jwt.expirationRefreshToken}")
    private Long EXPIRATION_REFRESH_TIME;
    @Value("${jwt.revoke}")
    private Boolean REVOKE;
    private static final Map<DeviceType, Integer> DEVICE_LIMIT = Map.of(
            DeviceType.DESKTOP, 1,
            DeviceType.MOBILE, 2
    );

    public AuthenticationResponse authenticated(AuthenticationRequest request, String deviceType, HttpServletRequest httpRequest) {
        var user = userRepository.findByUsername(request.getUsername()).orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
        DeviceType device = resolveDeviceType(deviceType);
        boolean authenticated = passwordEncoder.matches(request.getPassword(), user.getPassword());
        if (!authenticated)
            throw new ApiException(ErrorCode.USER_UNAUTHENTICATED);
        String username = user.getUsername();

        try {
            return AuthenticationResponse.builder()
                    .authenticated(true)
                    .token(generateToken(user))
                    .refreshToken(generateRefreshToken(
                            username,
                            device,
                            httpRequest).getRefreshToken())
                    .build();
        } catch (JOSEException e) {
            throw new RuntimeException(e);
        }
    }

    public void logout(String refreshToken) {
        var jwtRefreshToken = tokenRepository.findByRefreshToken(refreshToken)
                .orElseThrow(() -> new ApiException(ErrorCode.REFRESH_TOKEN_NOT_FOUND));

        if (jwtRefreshToken.isRevoked()) {
            throw new ApiException(ErrorCode.REFRESH_TOKEN_ALREADY_REVOKED);
        }

        jwtRefreshToken.setRevoked(true);
        tokenRepository.save(jwtRefreshToken);
    }

    public IntrospectResponse introspect(IntrospectRequest request) throws JOSEException, ParseException {
        var token = request.getToken();

        JWSVerifier verifier = new MACVerifier(SIGNER_KEY.getBytes());

        SignedJWT signedJWT = SignedJWT.parse(token);

        Date expirationTime = signedJWT.getJWTClaimsSet().getExpirationTime();

        var verified = signedJWT.verify(verifier);

        return IntrospectResponse.builder()
                .valid(verified && expirationTime.after(new Date()))
                .build();
    }

    public AuthenticationResponse refreshAccessToken(String refreshToken, HttpServletRequest httpRequest) throws ParseException, JOSEException {
        var jwtRefreshToken = tokenRepository.findByRefreshToken(refreshToken)
                .orElseThrow(() -> new ApiException(ErrorCode.REFRESH_TOKEN_NOT_FOUND));

        if (jwtRefreshToken.isRevoked()) {
            throw new ApiException(ErrorCode.REFRESH_TOKEN_ALREADY_REVOKED);
        }

        if(jwtRefreshToken.getExpiresAt().isBefore(Instant.now())) {
            throw new ApiException(ErrorCode.REFRESH_TOKEN_EXPIRED);
        }

        if(!Objects.equals(jwtRefreshToken.getIpAddress(), httpRequest.getRemoteAddr()) ||
            !Objects.equals(jwtRefreshToken.getUserAgent(), httpRequest.getHeader("User-Agent"))) {
            throw new ApiException(ErrorCode.INVALID_DEVICE_CONTEXT);
        }

        try {
            jwtRefreshToken.setRevoked(true);
            tokenRepository.save(jwtRefreshToken);
            Token newRefreshToken = generateRefreshToken(jwtRefreshToken.getUser().getUsername(), jwtRefreshToken.getDeviceType(), httpRequest);

            return AuthenticationResponse.builder()
                    .token(generateToken(jwtRefreshToken.getUser()))
                    .refreshToken(newRefreshToken.getRefreshToken())
                    .authenticated(true)
                    .build();
        } catch (JOSEException e) {
            throw new RuntimeException("Could not generate access token", e);
        }
    }

    private String generateToken(User user) throws JOSEException {

        JWSHeader jwsHeader = new JWSHeader(JWSAlgorithm.HS512);
        String jwtId = UUID.randomUUID().toString();

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .jwtID(jwtId)
                .subject(user.getId())
                .claim("preferred_username", user.getUsername())
                .issuer("finalProject.com")
                .issueTime(new Date())
                .expirationTime(new Date(Instant.now().plus(EXPIRATION_TIME, ChronoUnit.SECONDS).toEpochMilli()))
                .claim("authorities", buildScope(user))
                .build();

        Payload payload = new Payload(jwtClaimsSet.toJSONObject());
        JWSObject jwsObject = new JWSObject(jwsHeader, payload);

        jwsObject.sign(new MACSigner(SIGNER_KEY.getBytes()));

        return jwsObject.serialize();
    }

    private Token generateRefreshToken(String username, DeviceType deviceType, HttpServletRequest httpRequest) throws JOSEException {
        int maxAllowed = DEVICE_LIMIT.getOrDefault(deviceType, 1);
        List<Token> existingTokens = tokenRepository.findByUserUsernameAndDeviceTypeAndRevoked(username, deviceType, false);

        if (existingTokens.size() >= maxAllowed) {
            if (REVOKE) {
                for (Token token : existingTokens) {
                    token.setRevoked(true);
                }
                tokenRepository.saveAll(existingTokens);
            } else {
                throw new ApiException(ErrorCode.TOKEN_DEVICE_LIMIT_EXCEEDED);
            }
        }

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
        String userAgent = httpRequest.getHeader("User-Agent");
        String ipAddress = httpRequest.getRemoteAddr();

        Token token = Token.builder()
                .refreshToken(UUID.randomUUID().toString())
                .deviceType(deviceType)
                .userAgent(userAgent)
                .ipAddress(ipAddress)
                .expiresAt(Instant.now().plus(EXPIRATION_REFRESH_TIME, ChronoUnit.SECONDS))
                .revoked(false)
                .user(user)
                .build();

        return tokenRepository.save(token);
    }

    private String buildScope(User user) {
        if (user == null || user.getRole() == null) return "";

        Role role = user.getRole();
        Set<Permission> permissions = role.getPermissions();

        Set<String> scopes = new LinkedHashSet<>();

        scopes.add("ROLE_" + role.getRole());

        if (!CollectionUtils.isEmpty(permissions)) {
            permissions.forEach(permission -> scopes.add(permission.getPermission()));
        }

        return String.join(" ", scopes);
    }

    private DeviceType resolveDeviceType(String device) throws ApiException {
        try {
            return DeviceType.valueOf(device.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new ApiException(ErrorCode.INVALID_DEVICE_TYPE);
        }
    }
}
