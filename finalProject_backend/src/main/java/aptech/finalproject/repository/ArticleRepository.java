package aptech.finalproject.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.auth.Article;

@Repository
public interface ArticleRepository extends JpaRepository<Article, String> {
}
