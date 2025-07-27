package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.FavoritesRequest;
import aptech.finalproject.dto.response.exercise.FavoritesResponse;

import java.util.List;

public interface AdminFavoritesService {
    List<FavoritesResponse> getAll();
    FavoritesResponse getById(int id);
    FavoritesResponse create(FavoritesRequest request);
    FavoritesResponse update(int id, FavoritesRequest request);
    void delete(int id);
}

