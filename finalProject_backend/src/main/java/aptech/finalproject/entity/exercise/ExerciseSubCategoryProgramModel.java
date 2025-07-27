package aptech.finalproject.entity.exercise;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercise_sub_category_program")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class ExerciseSubCategoryProgramModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @ManyToOne
    @JoinColumn(name = "sub_category_id",referencedColumnName = "id")
    private ExerciseSubCategoryModel subCategory;
    @ManyToOne
    @JoinColumn(name = "program_id", referencedColumnName = "id")
    private ExerciseProgramsModel program; 
}
