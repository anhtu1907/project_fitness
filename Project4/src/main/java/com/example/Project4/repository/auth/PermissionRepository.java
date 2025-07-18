package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.*;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PermissionRepository extends JpaRepository<Permission, Long> {
    Optional<Permission> findByPermission(String permission);

    boolean existsByPermission(String permission);
}
