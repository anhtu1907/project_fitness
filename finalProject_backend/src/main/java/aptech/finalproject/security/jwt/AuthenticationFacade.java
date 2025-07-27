package aptech.finalproject.security.jwt;

import aptech.finalproject.model.CustomUserPrincipal;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationFacade {
    public Authentication getAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    public CustomUserPrincipal getCurrentUser() {
        return (CustomUserPrincipal) getAuthentication().getPrincipal();
    }
}
