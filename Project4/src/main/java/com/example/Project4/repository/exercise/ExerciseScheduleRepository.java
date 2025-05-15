package com.example.Project4.repository.exercise;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Project4.models.exercise.ExerciseScheduleModel;

public interface ExerciseScheduleRepository extends JpaRepository<ExerciseScheduleModel, Integer> {
    Optional<ExerciseScheduleModel> findByIdAndUser_Id(int scheduleId, int userId);
    List<ExerciseScheduleModel> findAllScheduleByUserId(int userId);
}
