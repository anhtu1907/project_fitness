package aptech.finalproject.security.config;

import aptech.finalproject.emums.FileType;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
@ConfigurationProperties(prefix = "app.config.paths")
@Data
public class AppPathProperties {

    private String publicDir = "public";
    private String uploadDir = "upload";
    private String imagesDir = "images";
    private String avatarsDir = "avatars";
    private String logosDir = "logos";
    private String articlesDir = "articles";
    private String commonImagesDir = "common";
    private String categoriesDir = "categories";
    private String pdfsDir = "pdfs";
    private String videosDir = "videos";
    private String docsDir = "docs";
    private String audiosDir = "audios";

    private final Path userDir = Paths.get(System.getProperty("user.dir"));


    public Path getPublicPath() {
        return userDir.resolve(Paths.get(publicDir));
    }

    public Path getUploadPath() { return userDir.resolve(Paths.get(uploadDir)); }


    private Path getCommonImagesPath() {
        return getUploadPath().resolve(Paths.get(commonImagesDir));
    }

    public Path getImagesPath() {
        return getUploadPath().resolve(Paths.get(imagesDir));
    }

    public Path getAvatarsPath() {
        return getCommonImagesPath().resolve(Paths.get(avatarsDir));
    }

    public Path getLogosPath() {
        return getCommonImagesPath().resolve(Paths.get(logosDir));
    }

    public Path getArticlesPath() {
        return getCommonImagesPath().resolve(Paths.get(articlesDir));
    }


    public Path getCategoriesPath() {
        return getCommonImagesPath().resolve(Paths.get(categoriesDir));
    }

    public Path getPdfsPath() {
        return getUploadPath().resolve(Paths.get(pdfsDir));
    }

    public Path getVideosPath() {
        return getUploadPath().resolve(Paths.get(videosDir));
    }

    public Path getDocsPath() {
        return getUploadPath().resolve(Paths.get(docsDir));
    }

    public Path getAudiosPath() {
        return getUploadPath().resolve(Paths.get(audiosDir));
    }

    public Path getPathByFileType(FileType fileType) {
        return
                switch (fileType.getTypeName()) {
                    case "image" -> getCommonImagesPath();
                    case "video" -> getVideosPath();
                    case "doc" -> getDocsPath();
                    case "audio" -> getAudiosPath();
                    case "pdf" -> getPdfsPath();
                    case "logo" -> getLogosPath();
                    case "article" -> getArticlesPath();
                    case "avatar" -> getAvatarsPath();
                    default -> throw new RuntimeException("Unsupported file type: " + fileType);
                };

    }
}
