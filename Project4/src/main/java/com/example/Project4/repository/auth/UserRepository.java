package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
     Optional<User> findByUsername(String username);

     Boolean existsByUsername(String username);

    Optional<User> findByEmail(String email);

    Optional<User> findById(String id);
}
