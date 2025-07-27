package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseFavoriteRequest;
import aptech.finalproject.dto.response.exercise.ExerciseFavoriteResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.exercise.ExerciseFavoriteModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.FavoritesModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ExerciseFavoriteMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "favorite", expression = "java(toFavorite(request.getFavoriteId()))")
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    ExerciseFavoriteModel toEntity(ExerciseFavoriteRequest request);

    @Mapping(source = "favorite.id", target = "favoriteId")
    @Mapping(source = "subCategory.id", target = "subCategoryId")
    @Mapping(source = "user.id", target = "userId")
    ExerciseFavoriteResponse toResponse(ExerciseFavoriteModel entity);

    // Helper methods for ID to entity references
    default FavoritesModel toFavorite(Integer id) {
        if (id == null) return null;
        FavoritesModel favorite = new FavoritesModel();
        favorite.setId(id);
        return favorite;
    }

    default ExerciseSubCategoryModel toSubCategory(Integer id) {
        if (id == null) return null;
        ExerciseSubCategoryModel sub = new ExerciseSubCategoryModel();
        sub.setId(id);
        return sub;
    }

    default User toUser(String id) {
        if (id == null) return null;
        User user = new User();
        user.setId(id);
        return user;
    }
}

