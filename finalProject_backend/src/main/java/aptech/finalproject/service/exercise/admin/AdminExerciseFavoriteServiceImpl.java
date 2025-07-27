package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseFavoriteRequest;
import aptech.finalproject.dto.response.exercise.ExerciseFavoriteResponse;
import aptech.finalproject.entity.exercise.ExerciseFavoriteModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseFavoriteMapper;
import aptech.finalproject.repository.exercise.ExerciseFavoriteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminExerciseFavoriteServiceImpl implements AdminExerciseFavoriteService {

    @Autowired
    private ExerciseFavoriteRepository exerciseFavoriteRepository;

    @Autowired
    private ExerciseFavoriteMapper exerciseFavoriteMapper;

    
    public ExerciseFavoriteResponse create(ExerciseFavoriteRequest request) {
        ExerciseFavoriteModel entity = exerciseFavoriteMapper.toEntity(request);
        ExerciseFavoriteModel saved = exerciseFavoriteRepository.save(entity);
        return exerciseFavoriteMapper.toResponse(saved);
    }

    
    public ExerciseFavoriteResponse update(int id, ExerciseFavoriteRequest request) {
        ExerciseFavoriteModel existing = exerciseFavoriteRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND));

        ExerciseFavoriteModel updated = exerciseFavoriteMapper.toEntity(request);
        updated.setId(id); // preserve ID
        ExerciseFavoriteModel saved = exerciseFavoriteRepository.save(updated);
        return exerciseFavoriteMapper.toResponse(saved);
    }

    
    public ExerciseFavoriteResponse getById(int id) {
        ExerciseFavoriteModel entity = exerciseFavoriteRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND));
        return exerciseFavoriteMapper.toResponse(entity);
    }

    
    public List<ExerciseFavoriteResponse> getAll() {
        return exerciseFavoriteRepository.findAll()
                .stream()
                .map(exerciseFavoriteMapper::toResponse)
                .collect(Collectors.toList());
    }

    
    public void delete(int id) {
        if (!exerciseFavoriteRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND);
        }
        exerciseFavoriteRepository.deleteById(id);
    }

    
    public List<ExerciseFavoriteResponse> getByUserId(String userId) {
        List<ExerciseFavoriteModel> favorites = exerciseFavoriteRepository.findByUserId(userId);
        return favorites.stream()
                .map(exerciseFavoriteMapper::toResponse)
                .collect(Collectors.toList());
    }
}

