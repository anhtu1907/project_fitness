package aptech.finalproject.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.auth.ArticleImage;

@Repository
public interface ArticleImageRepository extends JpaRepository<ArticleImage, String> {
}
