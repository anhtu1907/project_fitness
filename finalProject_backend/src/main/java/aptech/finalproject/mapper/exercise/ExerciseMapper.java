package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExercisesRequest;
import aptech.finalproject.dto.response.exercise.ExercisesResponse;
import aptech.finalproject.entity.exercise.ExerciseModeModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.ExercisesModel;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface ExerciseMapper {

    @Mapping(target = "equipment", ignore = true)
    @Mapping(target = "modes", ignore = true)
    @Mapping(target = "subCategory", ignore = true)
    @Mapping(target = "exerciseImage", ignore = true)
    ExercisesModel toEntity(ExercisesRequest request);

    @Mapping(target = "subCategoryIds", expression = "java(mapSubCategoryIds(entity.getSubCategory()))")
    @Mapping(target = "equipmentId", expression = "java(entity.getEquipment() != null ? entity.getEquipment().getId() : null)")
    @Mapping(target = "modeIds", expression = "java(mapModeIds(entity.getModes()))")
    ExercisesResponse toResponse(ExercisesModel entity);

    @Mapping(target = "equipment", ignore = true)
    @Mapping(target = "modes", ignore = true)
    @Mapping(target = "subCategory", ignore = true)
    @Mapping(target = "exerciseImage", ignore = true)
    void updateEntity(@MappingTarget ExercisesModel entity, ExercisesRequest request);

    default Set<Integer> mapSubCategoryIds(Set<ExerciseSubCategoryModel> subCategories) {
        if (subCategories == null)
            return null;
        return subCategories.stream()
                .map(ExerciseSubCategoryModel::getId)
                .collect(Collectors.toSet());
    }

    default Set<Integer> mapModeIds(Set<ExerciseModeModel> modes) {
        if (modes == null)
            return java.util.Collections.emptySet();
        return modes.stream()
                .map(ExerciseModeModel::getId)
                .collect(Collectors.toSet());
    }
}
