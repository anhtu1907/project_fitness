package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseSessionRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSessionResponse;
import aptech.finalproject.entity.exercise.ExerciseSessionModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseSessionMapper;
import aptech.finalproject.repository.exercise.ExerciseSessionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminExerciseSessionServiceImpl implements AdminExerciseSessionService {

    @Autowired
    private ExerciseSessionRepository exerciseSessionRepository;

    @Autowired
    private ExerciseSessionMapper exerciseSessionMapper;

    @Override
    public ExerciseSessionResponse create(ExerciseSessionRequest request) {
        ExerciseSessionModel model = exerciseSessionMapper.toEntity(request);
        ExerciseSessionModel saved = exerciseSessionRepository.save(model);
        return exerciseSessionMapper.toResponse(saved);
    }

    @Override
    public ExerciseSessionResponse update(int id, ExerciseSessionRequest request) {
        ExerciseSessionModel existing = exerciseSessionRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SESSION_NOT_FOUND));
        exerciseSessionMapper.updateEntity(existing, request);
        ExerciseSessionModel updated = exerciseSessionRepository.save(existing);
        return exerciseSessionMapper.toResponse(updated);
    }

    @Override
    public ExerciseSessionResponse getById(int id) {
        ExerciseSessionModel model = exerciseSessionRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SESSION_NOT_FOUND));
        return exerciseSessionMapper.toResponse(model);
    }

    @Override
    public List<ExerciseSessionResponse> getAll() {
        return exerciseSessionRepository.findAll().stream()
                .map(exerciseSessionMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(int id) {
        if (!exerciseSessionRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_SESSION_NOT_FOUND);
        }
        exerciseSessionRepository.deleteById(id);
    }
}

