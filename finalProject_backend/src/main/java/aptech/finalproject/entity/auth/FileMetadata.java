package aptech.finalproject.entity.auth;

import aptech.finalproject.emums.FileType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import lombok.*;

import java.time.Instant;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FileMetadata {
    @Id
    private String id;

    private String originalName;

    private String storedName;

    private String relativePath;

    @Enumerated(EnumType.STRING)
    private FileType fileType;

    private Long size;

    private Instant uploadAt;

}
