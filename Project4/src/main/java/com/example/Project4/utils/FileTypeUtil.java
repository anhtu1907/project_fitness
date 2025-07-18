package com.example.Project4.utils;

import com.example.Project4.emums.FileType;
import com.example.Project4.exception.ApiException;
import com.example.Project4.exception.ErrorCode;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;

public class FileTypeUtil {

    public static FileType fromMineType(String mimeType) {
        return Arrays.stream(FileType.values())
                .filter(type -> type.getMineType().contains(mimeType))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unsupported MIME type: " + mimeType));

    }

    public static FileType fromFileExtension(String extension) {
        String normalized = extension.toLowerCase().replace(".", "");
        return Arrays.stream(FileType.values())
                .filter(type -> type.getExtension().contains(normalized))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unsupported file extension: " + extension));
    }

    public static FileType detectFileType(MultipartFile file) {
        String mimeType = file.getContentType();

        if(mimeType != null && !mimeType.isBlank()) {
            try{
                return fromMineType(mimeType);
            }catch (IllegalArgumentException ignored) {}
        }

        String originalFilename = file.getOriginalFilename();
        if(originalFilename != null && originalFilename.contains(".")) {
            String extension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
            return fromFileExtension(extension);
        }

        throw new IllegalArgumentException("Cannot determine file type!");
    }


}