package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseProgramsRequest;
import aptech.finalproject.dto.response.exercise.ExerciseProgramsResponse;
import aptech.finalproject.entity.exercise.ExerciseProgramsModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseProgramsMapper;
import aptech.finalproject.repository.exercise.ExerciseProgramsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminExerciseProgramsServiceImpl implements AdminExerciseProgramsService {

    @Autowired
    private ExerciseProgramsRepository exerciseProgramsRepository;

    @Autowired
    private ExerciseProgramsMapper exerciseProgramsMapper;

    @Override
    public ExerciseProgramsResponse create(ExerciseProgramsRequest request) {
        ExerciseProgramsModel model = exerciseProgramsMapper.toEntity(request);
        ExerciseProgramsModel saved = exerciseProgramsRepository.save(model);
        return exerciseProgramsMapper.toResponse(saved);
    }

    @Override
    public ExerciseProgramsResponse update(int id, ExerciseProgramsRequest request) {
        ExerciseProgramsModel existing = exerciseProgramsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_PROGRAM_NOT_FOUND));
        exerciseProgramsMapper.updateEntity(existing, request);
        ExerciseProgramsModel updated = exerciseProgramsRepository.save(existing);
        return exerciseProgramsMapper.toResponse(updated);
    }

    @Override
    public ExerciseProgramsResponse getById(int id) {
        ExerciseProgramsModel model = exerciseProgramsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_PROGRAM_NOT_FOUND));
        return exerciseProgramsMapper.toResponse(model);
    }

    @Override
    public List<ExerciseProgramsResponse> getAll() {
        return exerciseProgramsRepository.findAll().stream()
                .map(exerciseProgramsMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(int id) {
        if (!exerciseProgramsRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_PROGRAM_NOT_FOUND);
        }
        exerciseProgramsRepository.deleteById(id);
    }
}

