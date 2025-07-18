package com.example.Project4.entity.auth;

import com.example.Project4.emums.ImageType;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ArticleImage {
    @Id
    private String id;

    @ManyToOne()
    private Article article;

    @OneToOne()
    private FileMetadata file;

    @Enumerated(EnumType.STRING)
    private ImageType imageType;

    private int displayOrder;
}
