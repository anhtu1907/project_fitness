package aptech.finalproject.entity.exercise;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseCategoryModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "category_name")
    private String categoryName;
    @Column(name = "category_image")
    private String categoryImage;

    @ManyToMany(mappedBy = "category")
    private Set<ExerciseSubCategoryModel> subCategories = new HashSet<>();
}
