package aptech.finalproject.repository.exercise;

import java.util.List;


import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import aptech.finalproject.entity.exercise.ExerciseProgressModel;

@Repository
public interface ExerciseProgressRepository extends JpaRepository<ExerciseProgressModel, Integer> {
    List<ExerciseProgressModel> findAllProgressByUserId(String userId);
}
