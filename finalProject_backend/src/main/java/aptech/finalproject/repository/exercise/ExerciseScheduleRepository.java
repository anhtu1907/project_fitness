package aptech.finalproject.repository.exercise;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import aptech.finalproject.entity.exercise.ExerciseScheduleModel;

public interface ExerciseScheduleRepository extends JpaRepository<ExerciseScheduleModel, Integer> {
    Optional<ExerciseScheduleModel> findByIdAndUser_Id(int scheduleId, String userId);
    List<ExerciseScheduleModel> findAllScheduleByUserId(String userId);
    List<ExerciseScheduleModel> findAllByScheduleTimeBefore(LocalDateTime start);
}
