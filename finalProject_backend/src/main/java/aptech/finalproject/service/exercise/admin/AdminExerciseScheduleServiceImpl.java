package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseScheduleRequest;
import aptech.finalproject.dto.response.exercise.ExerciseScheduleResponse;
import aptech.finalproject.entity.exercise.ExerciseScheduleModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseScheduleMapper;
import aptech.finalproject.repository.exercise.ExerciseScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminExerciseScheduleServiceImpl implements AdminExerciseScheduleService {

    @Autowired
    private ExerciseScheduleRepository exerciseScheduleRepository;

    @Autowired
    private ExerciseScheduleMapper exerciseScheduleMapper;

    
    public ExerciseScheduleResponse create(ExerciseScheduleRequest request) {
        ExerciseScheduleModel model = exerciseScheduleMapper.toEntity(request);
        ExerciseScheduleModel saved = exerciseScheduleRepository.save(model);
        return exerciseScheduleMapper.toResponse(saved);
    }

    
    public ExerciseScheduleResponse update(int id, ExerciseScheduleRequest request) {
        ExerciseScheduleModel existing = exerciseScheduleRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SCHEDULE_NOT_FOUND));
        exerciseScheduleMapper.updateEntity(existing, request);
        ExerciseScheduleModel updated = exerciseScheduleRepository.save(existing);
        return exerciseScheduleMapper.toResponse(updated);
    }

    
    public ExerciseScheduleResponse getById(int id) {
        ExerciseScheduleModel model = exerciseScheduleRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SCHEDULE_NOT_FOUND));
        return exerciseScheduleMapper.toResponse(model);
    }

    
    public List<ExerciseScheduleResponse> getAll() {
        return exerciseScheduleRepository.findAll().stream()
                .map(exerciseScheduleMapper::toResponse)
                .collect(Collectors.toList());
    }

    
    public void delete(int id) {
        if (!exerciseScheduleRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_SCHEDULE_NOT_FOUND);
        }
        exerciseScheduleRepository.deleteById(id);
    }
}

