package aptech.finalproject.repository.exercise;

import aptech.finalproject.entity.exercise.ExerciseProgramsModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ExerciseProgramsRepository extends JpaRepository<ExerciseProgramsModel, Integer> {
}
