package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseProgressRequest;
import aptech.finalproject.dto.response.exercise.ExerciseProgressResponse;
import aptech.finalproject.entity.exercise.ExerciseProgressModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseProgressMapper;
import aptech.finalproject.repository.exercise.ExerciseProgressRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminExerciseProgressServiceImpl implements AdminExerciseProgressService {

    @Autowired
    private ExerciseProgressRepository exerciseProgressRepository;

    @Autowired
    private ExerciseProgressMapper exerciseProgressMapper;

    @Override
    public ExerciseProgressResponse create(ExerciseProgressRequest request) {
        ExerciseProgressModel model = exerciseProgressMapper.toEntity(request);
        model.setLastUpdated(LocalDateTime.now());
        ExerciseProgressModel saved = exerciseProgressRepository.save(model);
        return exerciseProgressMapper.toResponse(saved);
    }

    @Override
    public ExerciseProgressResponse update(int id, ExerciseProgressRequest request) {
        ExerciseProgressModel existing = exerciseProgressRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_PROGRESS_NOT_FOUND));
        exerciseProgressMapper.updateEntity(existing, request);
        existing.setLastUpdated(LocalDateTime.now());
        ExerciseProgressModel updated = exerciseProgressRepository.save(existing);
        return exerciseProgressMapper.toResponse(updated);
    }

    @Override
    public ExerciseProgressResponse getById(int id) {
        ExerciseProgressModel model = exerciseProgressRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_PROGRESS_NOT_FOUND));
        return exerciseProgressMapper.toResponse(model);
    }

    @Override
    public List<ExerciseProgressResponse> getAll() {
        return exerciseProgressRepository.findAll().stream()
                .map(exerciseProgressMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(int id) {
        if (!exerciseProgressRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_PROGRESS_NOT_FOUND);
        }
        exerciseProgressRepository.deleteById(id);
    }
}
