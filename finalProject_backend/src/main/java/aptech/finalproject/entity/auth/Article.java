package aptech.finalproject.entity.auth;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Article {
    @Id
    private String id;

    private String title;

    private String description;

    private String content;

    private String slug;

    private String author;

    private String category;

    private Instant createdAt;

    private Instant publishedAt;

    private Instant modifiedAt;

    @OneToOne
    private FileMetadata thumbnail;

    @OneToMany(mappedBy = "article", cascade = CascadeType.ALL)
    private List<ArticleImage> images;
}
