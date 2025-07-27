package aptech.finalproject.service;

import aptech.finalproject.dto.request.AuthenticationRequest;
import aptech.finalproject.dto.request.IntrospectRequest;
import aptech.finalproject.dto.response.AuthenticationResponse;
import aptech.finalproject.dto.response.IntrospectResponse;
import com.nimbusds.jose.JOSEException;
import jakarta.servlet.http.HttpServletRequest;

import java.text.ParseException;


public interface AuthenticationService {
    AuthenticationResponse authenticated(AuthenticationRequest request, String deviceType, HttpServletRequest httpServletRequest) throws JOSEException, ParseException;

    IntrospectResponse introspect(IntrospectRequest request) throws JOSEException, ParseException;

    void logout(String refreshToken);

    AuthenticationResponse refreshAccessToken(String refreshToken, HttpServletRequest httpServletRequest) throws ParseException, JOSEException;
}
