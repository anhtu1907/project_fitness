package aptech.finalproject.controller.auth;

import aptech.finalproject.dto.request.AuthenticationRequest;
import aptech.finalproject.dto.request.IntrospectRequest;
import aptech.finalproject.dto.request.RefreshTokenRequest;
import aptech.finalproject.dto.request.ResetPasswordRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.AuthenticationResponse;
import aptech.finalproject.dto.response.IntrospectResponse;
import aptech.finalproject.service.AuthenticationService;
import aptech.finalproject.service.PasswordResetTokenService;
import com.nimbusds.jose.JOSEException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthenticationController {
    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private PasswordResetTokenService passwordResetTokenService;


    @PostMapping("/login")
    public ApiResponse<AuthenticationResponse> login(
            @RequestBody AuthenticationRequest request,
            @RequestHeader("X-Device-Type") String deviceType,
            HttpServletRequest httpRequest) throws JOSEException, ParseException {

        return ApiResponse.ok(authenticationService.authenticated(request, deviceType, httpRequest));
    }

    @PostMapping("/introspect")
    public ApiResponse<IntrospectResponse> introspectToken(@RequestBody IntrospectRequest request) throws ParseException, JOSEException {
        return ApiResponse.ok(authenticationService.introspect(request));
    }

    @PostMapping("/logout")
    public ApiResponse<?> logout(@RequestBody RefreshTokenRequest request)  {
        authenticationService.logout(request.getRefreshToken());
        return ApiResponse.ok();
    }

    @PostMapping("/refresh-token")

    public ApiResponse<?> refreshToken(@RequestBody RefreshTokenRequest refreshToken, HttpServletRequest httpServletRequest) throws ParseException, JOSEException {
        return ApiResponse.ok(authenticationService.refreshAccessToken(refreshToken.getRefreshToken(), httpServletRequest));
    }

    @PostMapping("/forgot-password")
    public ApiResponse<?> forgotPassword(@RequestBody Map<String,String> request)  {
        String email = request.get("email");
        passwordResetTokenService.sendResetPasswordLink(email);
        return ApiResponse.ok("Reset password link sent to email.");
    }

    @PostMapping("/reset-password")
    public ApiResponse<?> resetPassword(@RequestBody ResetPasswordRequest request)  {
        passwordResetTokenService.resetPassword(request);
        return ApiResponse.ok("Password has been reset successfully.");
    }

}
