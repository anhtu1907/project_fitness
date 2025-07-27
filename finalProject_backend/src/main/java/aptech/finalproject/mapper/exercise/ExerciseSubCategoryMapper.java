package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseSubCategoryRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSubCategoryResponse;
import aptech.finalproject.entity.exercise.ExerciseCategoryModel;
import aptech.finalproject.entity.exercise.ExerciseScheduleModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.ExercisesModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface ExerciseSubCategoryMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subCategoryImage", ignore = true) // xử lý ở service
    @Mapping(target = "exercises", ignore = true)
    @Mapping(target = "favorite", ignore = true)
    @Mapping(target = "schedules", ignore = true)
    @Mapping(target = "category", expression = "java(toCategorySet(request.getCategoryIds()))")
    ExerciseSubCategoryModel toEntity(ExerciseSubCategoryRequest request);

    @Mapping(source = "category", target = "categoryIds", qualifiedByName = "mapCategoryIds")
    @Mapping(source = "exercises", target = "exerciseIds", qualifiedByName = "mapExerciseIds")
    @Mapping(source = "schedules", target = "scheduleIds", qualifiedByName = "mapScheduleIds")
    ExerciseSubCategoryResponse toResponse(ExerciseSubCategoryModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subCategoryImage", ignore = true)
    @Mapping(target = "exercises", ignore = true)
    @Mapping(target = "favorite", ignore = true)
    @Mapping(target = "schedules", ignore = true)
    @Mapping(target = "category", expression = "java(toCategorySet(request.getCategoryIds()))")
    void updateEntity(@MappingTarget ExerciseSubCategoryModel entity, ExerciseSubCategoryRequest request);

    // ===== Helper mapping methods =====

    default Set<ExerciseCategoryModel> toCategorySet(Set<Integer> ids) {
        if (ids == null) return new HashSet<>();
        return ids.stream().map(id -> {
            ExerciseCategoryModel c = new ExerciseCategoryModel();
            c.setId(id);
            return c;
        }).collect(Collectors.toSet());
    }

    @Named("mapCategoryIds")
    default Set<Integer> mapCategoryIds(Set<ExerciseCategoryModel> categories) {
        if (categories == null) return new HashSet<>();
        return categories.stream().map(ExerciseCategoryModel::getId).collect(Collectors.toSet());
    }

    @Named("mapExerciseIds")
    default Set<Integer> mapExerciseIds(Set<ExercisesModel> exercises) {
        if (exercises == null) return new HashSet<>();
        return exercises.stream().map(ExercisesModel::getId).collect(Collectors.toSet());
    }

    @Named("mapScheduleIds")
    default List<Integer> mapScheduleIds(List<ExerciseScheduleModel> schedules) {
        if (schedules == null) return new ArrayList<>();
        return schedules.stream().map(ExerciseScheduleModel::getId).collect(Collectors.toList());
    }
}
