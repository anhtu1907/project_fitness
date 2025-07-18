package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByRole(String role);
    boolean existsByRole(String role);
}
