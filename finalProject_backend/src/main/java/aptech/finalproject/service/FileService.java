package aptech.finalproject.service;

import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.exception.ApiException;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

public interface FileService {
    FileMetadata saveFile(MultipartFile file, Optional<String> groupPath) throws ApiException;
    Resource getFileContent(FileMetadata metadata) throws ApiException;
    Resource getFile(String fileName);
    void deleteImage(String storedName);
    FileMetadata findById(String id);
    List<FileMetadata> findAll();
    FileMetadata findByFileName(String fileName);

    FileMetadata saveFileByOriginal(MultipartFile file, Optional<String> groupPath) throws ApiException;
}
