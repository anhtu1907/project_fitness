package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseModeRequest;
import aptech.finalproject.dto.response.exercise.ExerciseModeResponse;
import aptech.finalproject.entity.exercise.ExerciseModeModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseModeMapper;
import aptech.finalproject.repository.exercise.ExerciseModeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminExerciseModeServiceImpl implements AdminExerciseModeService {

    @Autowired
    private ExerciseModeRepository exerciseModeRepository;

    @Autowired
    private ExerciseModeMapper exerciseModeMapper;

    @Override
    public ExerciseModeResponse create(ExerciseModeRequest request) {
        ExerciseModeModel model = exerciseModeMapper.toEntity(request);
        ExerciseModeModel saved = exerciseModeRepository.save(model);
        return exerciseModeMapper.toResponse(saved);
    }

    @Override
    public ExerciseModeResponse update(int id, ExerciseModeRequest request) {
        ExerciseModeModel existing = exerciseModeRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_MODE_NOT_FOUND));
        exerciseModeMapper.updateEntity(existing, request);
        ExerciseModeModel updated = exerciseModeRepository.save(existing);
        return exerciseModeMapper.toResponse(updated);
    }

    @Override
    public ExerciseModeResponse getById(int id) {
        ExerciseModeModel model = exerciseModeRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_MODE_NOT_FOUND));
        return exerciseModeMapper.toResponse(model);
    }

    @Override
    public List<ExerciseModeResponse> getAll() {
        return exerciseModeRepository.findAll()
                .stream()
                .map(exerciseModeMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(int id) {
        if (!exerciseModeRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_MODE_NOT_FOUND);
        }
        exerciseModeRepository.deleteById(id);
    }
}

