package com.example.Project4.repository.auth;

import com.example.Project4.entity.auth.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ArticleImageRepository extends JpaRepository<ArticleImage, String> {
}
