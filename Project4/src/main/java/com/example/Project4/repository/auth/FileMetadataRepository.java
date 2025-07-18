package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FileMetadataRepository  extends JpaRepository<FileMetadata, String> {
    Optional<FileMetadata> findByStoredName(String storedName);
}
