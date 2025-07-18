package com.example.Project4.controller.auth;

import com.example.Project4.dto.auth.response.ApiResponse;
import com.example.Project4.entity.auth.FileMetadata;
import com.example.Project4.security.config.AppPathProperties;
import com.example.Project4.service.auth.FileService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;

@RestController
@RequestMapping("/resources")
public class ResourceController {
    @Autowired
    FileService fileService;
    @Autowired
    AppPathProperties appPath;

    @PostMapping
    public ApiResponse<FileMetadata> saveFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "group", required = false) String group) {

        FileMetadata metadata = fileService.saveFile(file, Optional.ofNullable(group));
        return ApiResponse.ok(metadata);
    }


    @GetMapping("/{file}")
    public ResponseEntity<Resource> getFile(@PathVariable String file) throws IOException {
        FileMetadata metadata = fileService.findByFileName(file);
        Resource resource = fileService.getFile(file);

        Path path = Paths.get(appPath.getUploadPath().toString(), metadata.getRelativePath(), metadata.getStoredName());
        String mimeType = Files.probeContentType(path);
        MediaType mediaType = mimeType != null ? MediaType.parseMediaType(mimeType) : MediaType.APPLICATION_OCTET_STREAM;

        return ResponseEntity.ok()
                .contentType(mediaType)
                .body(resource);
    }

    @GetMapping("/download/{file}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String file) throws IOException {
        FileMetadata metadata = fileService.findByFileName(file);
        System.out.println(metadata.getRelativePath());
        Resource resource = fileService.getFile(file);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + file + "\"")
                .body(resource);

    }
}
