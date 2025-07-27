package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseUserRequest;
import aptech.finalproject.dto.response.exercise.ExerciseUserResponse;
import aptech.finalproject.entity.exercise.ExerciseUserModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseUserMapper;
import aptech.finalproject.repository.exercise.ExerciseUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminExerciseUserServiceImpl implements AdminExerciseUserService {

    private final ExerciseUserRepository repository;
    private final ExerciseUserMapper mapper;


    public List<ExerciseUserResponse> getAll() {
        return repository.findAll().stream()
                .map(mapper::toResponse)
                .collect(Collectors.toList());
    }


    public ExerciseUserResponse getById(int id) {
        ExerciseUserModel entity = repository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_USER_NOT_FOUND));
        return mapper.toResponse(entity);
    }


    public ExerciseUserResponse create(ExerciseUserRequest request) {
        ExerciseUserModel entity = mapper.toEntity(request);
        return mapper.toResponse(repository.save(entity));
    }


    public ExerciseUserResponse update(int id, ExerciseUserRequest request) {
        ExerciseUserModel existing = repository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_USER_NOT_FOUND));
        mapper.updateEntity(existing, request);
        return mapper.toResponse(repository.save(existing));
    }


    public void delete(int id) {
        ExerciseUserModel entity = repository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_USER_NOT_FOUND));
        repository.delete(entity);
    }
}

