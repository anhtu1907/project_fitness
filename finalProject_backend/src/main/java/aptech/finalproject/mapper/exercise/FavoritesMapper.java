package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.FavoritesRequest;
import aptech.finalproject.dto.response.exercise.FavoritesResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.exercise.ExerciseFavoriteModel;
import aptech.finalproject.entity.exercise.FavoritesModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface FavoritesMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "exerciseFavorites", ignore = true) // Do không map từ request
    FavoritesModel toEntity(FavoritesRequest request);

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "exerciseFavorites", target = "exerciseFavoriteIds")
    FavoritesResponse toResponse(FavoritesModel entity);

    List<FavoritesResponse> toResponseList(List<FavoritesModel> entities);

    // ===== Helper method =====
    default User toUser(String id) {
        if (id == null) return null;
        User user = new User();
        user.setId(id);
        return user;
    }

    default List<Integer> mapExerciseFavoritesToIds(List<ExerciseFavoriteModel> list) {
        if (list == null) return new ArrayList<>();
        return list.stream().map(ExerciseFavoriteModel::getId).collect(Collectors.toList());
    }
}

