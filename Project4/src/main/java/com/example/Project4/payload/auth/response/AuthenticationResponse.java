package com.example.Project4.payload.auth.response;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthenticationResponse {
    String token;
    String refreshToken;
    private boolean authenticated;
}
