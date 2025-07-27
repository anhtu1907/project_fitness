package aptech.finalproject.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.auth.FileMetadata;

import java.util.Optional;

@Repository
public interface FileMetadataRepository  extends JpaRepository<FileMetadata, String> {
    Optional<FileMetadata> findByStoredName(String storedName);
}
