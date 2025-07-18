package com.example.Project4.service.auth;

import java.util.List;
import java.util.Optional;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import com.example.Project4.entity.auth.FileMetadata;
import com.example.Project4.exception.ApiException;

public interface FileService {
     FileMetadata saveFile(MultipartFile file, Optional<String> groupPath) throws ApiException;
    Resource getFileContent(FileMetadata metadata) throws ApiException;
    Resource getFile(String fileName);
    void deleteImage(String storedName);
    FileMetadata findById(String id);
    List<FileMetadata> findAll();
    FileMetadata findByFileName(String fileName);
}
