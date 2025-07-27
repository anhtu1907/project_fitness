package aptech.finalproject.entity.exercise;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "exercise_sub_category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseSubCategoryModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "sub_category_name")
    private String subCategoryName;
    @Column(name = "sub_category_image")
    private String subCategoryImage;
    @Column(name = "description")
    private String description;
    @ManyToMany
    @JoinTable(name = "category_subcategories", joinColumns = @JoinColumn(name = "sub_category_id"), inverseJoinColumns = @JoinColumn(name = "category_id"))
    private Set<ExerciseCategoryModel> category = new HashSet<>();

    @ManyToMany(mappedBy = "subCategory")
    private Set<ExercisesModel> exercises = new HashSet<>();
    @OneToMany(mappedBy = "subCategory")
    private Set<ExerciseFavoriteModel> favorite = new HashSet<>();
    @OneToMany(mappedBy = "subCategory", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExerciseScheduleModel> schedules = new ArrayList<>();
}
