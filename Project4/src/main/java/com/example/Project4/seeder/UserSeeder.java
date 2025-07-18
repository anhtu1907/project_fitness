package com.example.Project4.seeder;

import com.example.Project4.emums.*;
import com.example.Project4.entity.auth.*;
import com.example.Project4.repository.auth.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Component
@Transactional
public class UserSeeder implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PermissionRepository permissionRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);

    @Override
    public void run(String... args) throws Exception {

        // 1. Seed all permissions
        for (PredefinedPermission predefined : PredefinedPermission.values()) {
            Optional<Permission> existing = permissionRepository.findByPermission(predefined.getPermission());
            if (existing.isEmpty()) {
                Permission permission = new Permission();
                permission.setPermission(predefined.getPermission());
                permission.setDescription(predefined.getDescription());
                permissionRepository.save(permission);
            }
        }

        // Load all permissions to a map for quick access
        Map<String, Permission> permissionMap = permissionRepository.findAll()
                .stream().collect(Collectors.toMap(Permission::getPermission, p -> p));

        // 2. Define role-permission mapping
        Map<PredefinedRole, List<PredefinedPermission>> rolePermissionMap = Map.of(
//                PredefinedRole.SUPER_ADMIN, Arrays.asList(PredefinedPermission.values()),
                PredefinedRole.ADMIN, Arrays.asList(
                        PredefinedPermission.MANAGE_USERS, PredefinedPermission.VIEW_USERS,
                        PredefinedPermission.RESET_PASSWORD, PredefinedPermission.ASSIGN_ROLES,
                        PredefinedPermission.MANAGE_ROLES, PredefinedPermission.VIEW_ROLES, PredefinedPermission.MANAGE_PERMISSIONS,
                        PredefinedPermission.MANAGE_SETTINGS, PredefinedPermission.ACCESS_ADMIN_PANEL,
                        PredefinedPermission.VIEW_REPORTS, PredefinedPermission.EXPORT_DATA, PredefinedPermission.VIEW_AUDIT_LOGS
                ),
                PredefinedRole.MODERATOR, Arrays.asList(
                        PredefinedPermission.VIEW_USERS, PredefinedPermission.RESET_PASSWORD, PredefinedPermission.ASSIGN_ROLES,
                        PredefinedPermission.VIEW_ROLES, PredefinedPermission.VIEW_MESSAGES,
                        PredefinedPermission.VIEW_AUDIT_LOGS, PredefinedPermission.VIEW_REPORTS,
                        PredefinedPermission.CREATE_POST, PredefinedPermission.EDIT_POST,
                        PredefinedPermission.DELETE_POST, PredefinedPermission.PUBLISH_CONTENT
                ),
                PredefinedRole.USER, Arrays.asList(
                        PredefinedPermission.VIEW_PRODUCTS, PredefinedPermission.VIEW_INVOICES, PredefinedPermission.VIEW_MESSAGES
                )
        );

        // 3. Seed roles with mapped permissions
        for (PredefinedRole predefined : PredefinedRole.values()) {
            Optional<Role> existing = roleRepository.findByRole(predefined.getRole());

            if (existing.isEmpty()) {
                Role role = new Role();
                role.setRole(predefined.getRole());
                role.setDescription(predefined.getDescription());
                roleRepository.save(role);

                // Gán permission nếu có ánh xạ
                List<PredefinedPermission> mappedPermissions = rolePermissionMap.get(predefined);
                if (mappedPermissions != null) {
                    Set<Permission> permissions = mappedPermissions.stream()
                            .map(p -> permissionMap.get(p.getPermission()))
                            .collect(Collectors.toSet());
                    role.setPermissions(permissions);
                    roleRepository.save(role);
                }
            }

        }

        // 4. Seed user: admin
        if (!userRepository.existsByUsername("admin")) {
            Optional<Role> adminRole = roleRepository.findByRole(PredefinedRole.ADMIN.getRole());
            adminRole.ifPresent(role -> {
                User admin = User.builder()
                        .username("admin")
                        .email("admin@admin.com")
                        .password(passwordEncoder.encode("123"))
                        .role(role)
                        .active(true)
                        .build();
                userRepository.save(admin);
                System.out.println("Admin user created.");
            });
        }

        // 5. Seed user: user1
        if (!userRepository.existsByUsername("user1")) {
            Optional<Role> userRole = roleRepository.findByRole(PredefinedRole.USER.getRole());
            userRole.ifPresent(role -> {
                User user = User.builder()
                        .username("user1")
                        .email("user@auser.com")
                        .password(passwordEncoder.encode("123"))
                        .role(role)
                        .active(true)
                        .build();
                userRepository.save(user);
                System.out.println("User1 user created.");
            });
        }

        // 6. Seed user: moderator
        if (!userRepository.existsByUsername("moderator")) {
            Optional<Role> moderatorRole = roleRepository.findByRole(PredefinedRole.MODERATOR.getRole());
            moderatorRole.ifPresent(role -> {
                User mod = User.builder()
                        .username("moderator")
                        .email("moderator@mod.com")
                        .password(passwordEncoder.encode("123"))
                        .role(role)
                        .active(true)
                        .build();
                userRepository.save(mod);
                System.out.println("Moderator user created.");
            });
        }
    }
}

