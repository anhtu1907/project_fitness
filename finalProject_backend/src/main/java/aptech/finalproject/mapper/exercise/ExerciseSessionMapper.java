package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseSessionRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSessionResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.exercise.ExerciseSessionModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.ExercisesModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseSessionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "exercise", expression = "java(toExercise(request.getExerciseId()))")
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    ExerciseSessionModel toEntity(ExerciseSessionRequest request);

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "exercise.id", target = "exerciseId")
    @Mapping(source = "subCategory.id", target = "subCategoryId")
    ExerciseSessionResponse toResponse(ExerciseSessionModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "exercise", expression = "java(toExercise(request.getExerciseId()))")
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    void updateEntity(@MappingTarget ExerciseSessionModel entity, ExerciseSessionRequest request);

    default User toUser(String id) {
        if (id == null) return null;
        User u = new User();
        u.setId(id);
        return u;
    }

    default ExercisesModel toExercise(Integer id) {
        if (id == null) return null;
        ExercisesModel e = new ExercisesModel();
        e.setId(id);
        return e;
    }

    default ExerciseSubCategoryModel toSubCategory(Integer id) {
        if (id == null) return null;
        ExerciseSubCategoryModel sub = new ExerciseSubCategoryModel();
        sub.setId(id);
        return sub;
    }
}

