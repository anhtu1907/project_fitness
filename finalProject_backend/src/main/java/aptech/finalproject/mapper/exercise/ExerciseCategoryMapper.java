package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseCategoryRequest;
import aptech.finalproject.dto.response.exercise.ExerciseCategoryResponse;
import aptech.finalproject.entity.exercise.ExerciseCategoryModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface ExerciseCategoryMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "categoryImage", ignore = true)
    @Mapping(target = "subCategories", ignore = true)
    ExerciseCategoryModel toEntity(ExerciseCategoryRequest request);

    @Mapping(target = "subCategoryIds", expression = "java(mapSubCategoryIds(entity))")
    ExerciseCategoryResponse toResponse(ExerciseCategoryModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "categoryImage", ignore = true)
    @Mapping(target = "subCategories", ignore = true)
    void updateEntity(@MappingTarget ExerciseCategoryModel entity, ExerciseCategoryRequest request);

    // Custom method to map subCategory IDs
    default Set<Integer> mapSubCategoryIds(ExerciseCategoryModel entity) {
        if (entity.getSubCategories() == null) return new HashSet<>();
        return entity.getSubCategories().stream()
                .map(ExerciseSubCategoryModel::getId)
                .collect(Collectors.toSet());
    }
}
