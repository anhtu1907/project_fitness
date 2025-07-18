package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.nimbusds.jose.JOSEException;
import jakarta.servlet.http.HttpServletRequest;

import java.text.ParseException;


public interface AuthenticationService {
     AuthenticationResponse authenticated(AuthenticationRequest request, String deviceType, HttpServletRequest httpServletRequest) throws JOSEException, ParseException;

    IntrospectResponse introspect(IntrospectRequest request) throws JOSEException, ParseException;

    void logout(String refreshToken);

    AuthenticationResponse refreshAccessToken(String refreshToken, HttpServletRequest httpServletRequest) throws ParseException, JOSEException;
}
