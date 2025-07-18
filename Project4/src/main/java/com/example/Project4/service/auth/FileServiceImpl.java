package com.example.Project4.service.auth;
import com.example.Project4.emums.*;
import com.example.Project4.entity.auth.*;
import com.example.Project4.exception.*;
import com.example.Project4.repository.auth.*;
import com.example.Project4.security.config.AppPathProperties;
import com.example.Project4.utils.FileTypeUtil;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Slf4j
public class FileServiceImpl implements FileService {
    @Autowired
    FileMetadataRepository fileMetadataRepository;

    @Autowired
    AppPathProperties appPath;

    @Value("${app.config.file.max-size}")
    long maxSize ;

    public FileMetadata saveFile(MultipartFile file, Optional<String> groupPath) throws ApiException {
        validateFile(file);

        FileType fileType = FileTypeUtil.detectFileType(file);
        String extension = fileType.getExtension().get(0);
        String storedName = UUID.randomUUID() + "." + extension;

        String relativePath = groupPath.orElse(fileType.getTypeName()); // fallback theo FileType

        Path targetDir = appPath.getUploadPath().resolve(relativePath);
        Path targetPath = targetDir.resolve(storedName);

        try {
            Files.createDirectories(targetDir);
            file.transferTo(targetPath.toFile());
        } catch (IOException e) {
            throw new ApiException(ErrorCode.FILE_UPLOAD_FAILED);
        }

        FileMetadata metadata = FileMetadata.builder()
                .id(UUID.randomUUID().toString())
                .originalName(file.getOriginalFilename())
                .storedName(storedName)
                .relativePath(relativePath)
                .fileType(fileType)
                .size(file.getSize())
                .uploadAt(Instant.now())
                .build();

        try {
            return fileMetadataRepository.save(metadata);
        } catch (Exception e) {
            try {
                Files.deleteIfExists(targetPath);
            } catch (IOException ex) {
                log.error("Failed to delete file after DB error", ex);
            }
            throw new ApiException(ErrorCode.DATABASE_ERROR);
        }
    }

    public Resource getFile(String fileName) {
        FileMetadata metadata = fileMetadataRepository.findByStoredName(fileName).orElseThrow(()->new ApiException(ErrorCode.FILE_NOT_FOUND));

        return getFileContent(metadata);
    }

    public Resource getFileContent(FileMetadata metadata) throws ApiException {

        Path path = appPath.getUploadPath()
                .resolve(metadata.getRelativePath())
                .resolve(metadata.getStoredName());

        if (!Files.exists(path)) {
            throw new ApiException(ErrorCode.FILE_NOT_FOUND);
        }

        try {
            return new UrlResource(path.toUri());
        } catch (MalformedURLException e) {
            throw new ApiException(ErrorCode.FILE_READ_FAILED);
        }
    }

    public void deleteImage(String storedName) {
        FileMetadata fileMetadata = fileMetadataRepository.findByStoredName(storedName)
                .orElseThrow(() -> new ApiException(ErrorCode.FILE_NOT_FOUND));

        try {
            Path filePath = appPath.getImagesPath()
                    .resolve(fileMetadata.getFileType().getTypeName())
                    .resolve(storedName);

            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            throw new RuntimeException("Failed to delete file", e);
        }

    }
    public List<FileMetadata> findAll() {
        return fileMetadataRepository.findAll();
    }

    public FileMetadata findById(String id) {
        return fileMetadataRepository.findById(id).orElseThrow(() -> new ApiException(ErrorCode.FILE_NOT_FOUND));
    }

    public FileMetadata findByFileName(String fileName) {
        return fileMetadataRepository.findByStoredName(fileName).orElseThrow(() -> new ApiException(ErrorCode.FILE_NOT_FOUND));
    }

    private void validateFile(MultipartFile file) {
        if (file.isEmpty())
            throw new ApiException(ErrorCode.FILE_IS_EMPTY);

        if (file.getOriginalFilename() == null || file.getOriginalFilename().isBlank())
            throw new ApiException(ErrorCode.NOT_SUPPORTED_FILE_TYPE);

        if (file.getSize() > maxSize)
            throw new ApiException(ErrorCode.FILE_TOO_LARGE);
    }

    private String generateStoredFileName(String extension) {
        return UUID.randomUUID() + "." + extension;
    }

    private FileMetadata buildFileMetadata(MultipartFile file, String storedName, FileType fileType) {
        return FileMetadata.builder()
                .id(UUID.randomUUID().toString())
                .originalName(file.getOriginalFilename())
                .storedName(storedName)
                .fileType(fileType)
                .size(file.getSize())
                .uploadAt(Instant.now())
                .build();
    }

}
