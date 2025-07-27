package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.FavoritesRequest;
import aptech.finalproject.dto.response.exercise.FavoritesResponse;
import aptech.finalproject.entity.exercise.FavoritesModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.FavoritesMapper;
import aptech.finalproject.repository.exercise.FavoritesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminFavoritesServiceImpl implements AdminFavoritesService {

    private final FavoritesRepository favoritesRepository;
    private final FavoritesMapper favoritesMapper;

    @Override
    public List<FavoritesResponse> getAll() {
        return favoritesMapper.toResponseList(favoritesRepository.findAll());
    }

    @Override
    public FavoritesResponse getById(int id) {
        FavoritesModel entity = favoritesRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND));
        return favoritesMapper.toResponse(entity);
    }

    @Override
    public FavoritesResponse create(FavoritesRequest request) {
        FavoritesModel entity = favoritesMapper.toEntity(request);
        return favoritesMapper.toResponse(favoritesRepository.save(entity));
    }

    @Override
    public FavoritesResponse update(int id, FavoritesRequest request) {
        FavoritesModel existing = favoritesRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND));
        existing.setFavoriteName(request.getFavoriteName());
        existing.setUser(favoritesMapper.toUser(request.getUserId()));
        return favoritesMapper.toResponse(favoritesRepository.save(existing));
    }

    @Override
    public void delete(int id) {
        FavoritesModel entity = favoritesRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND));
        favoritesRepository.delete(entity);
    }
}

