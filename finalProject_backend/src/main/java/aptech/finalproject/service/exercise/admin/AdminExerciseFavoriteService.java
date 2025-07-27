package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseFavoriteRequest;
import aptech.finalproject.dto.response.exercise.ExerciseFavoriteResponse;

import java.util.List;

public interface AdminExerciseFavoriteService {
    ExerciseFavoriteResponse create(ExerciseFavoriteRequest request);
    ExerciseFavoriteResponse update(int id, ExerciseFavoriteRequest request);
    ExerciseFavoriteResponse getById(int id);
    List<ExerciseFavoriteResponse> getAll();
    void delete(int id);
    List<ExerciseFavoriteResponse> getByUserId(String userId);
}
