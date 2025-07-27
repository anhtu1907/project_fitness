package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseScheduleRequest;
import aptech.finalproject.dto.response.exercise.ExerciseScheduleResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.exercise.ExerciseScheduleModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseScheduleMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    ExerciseScheduleModel toEntity(ExerciseScheduleRequest request);

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "subCategory.id", target = "subCategoryId")
    ExerciseScheduleResponse toResponse(ExerciseScheduleModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    void updateEntity(@MappingTarget ExerciseScheduleModel entity, ExerciseScheduleRequest request);

    // Helper methods
    default User toUser(String id) {
        if (id == null) return null;
        User user = new User();
        user.setId(id);
        return user;
    }

    default ExerciseSubCategoryModel toSubCategory(Integer id) {
        if (id == null) return null;
        ExerciseSubCategoryModel sub = new ExerciseSubCategoryModel();
        sub.setId(id);
        return sub;
    }
}
