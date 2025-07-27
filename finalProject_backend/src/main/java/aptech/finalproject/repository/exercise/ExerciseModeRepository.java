package aptech.finalproject.repository.exercise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.exercise.ExerciseModeModel;

@Repository
public interface ExerciseModeRepository extends JpaRepository<ExerciseModeModel,Integer>{
    
}
