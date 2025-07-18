package com.example.Project4.emums;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public enum PredefinedRole {
    SUPER_ADMIN("SUPER_ADMIN", "System owner, full privileges"),
    ADMIN("ADMIN", "Application admin with user and config access"),
    MODERATOR("MODERATOR", "Moderate content and manage users"),
    MANAGER("MANAGER", "Business level operations and approvals"),
    STAFF("STAFF", "Limited backend access for daily tasks"),
    EDITOR("EDITOR", "Content creator and publisher"),
    VIEWER("VIEWER", "Read-only access"),
    USER("USER", "Frontend user with basic privileges"),
    GUEST("GUEST", "Anonymous or trial access");

    private String role;
    private String description;
}
