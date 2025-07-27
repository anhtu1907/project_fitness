package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseModeRequest;
import aptech.finalproject.dto.response.exercise.ExerciseModeResponse;
import aptech.finalproject.entity.exercise.ExerciseModeModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseModeMapper {

    @Mapping(target = "id", ignore = true)
    ExerciseModeModel toEntity(ExerciseModeRequest request);

    ExerciseModeResponse toResponse(ExerciseModeModel entity);

    @Mapping(target = "id", ignore = true)
    void updateEntity(@MappingTarget ExerciseModeModel entity, ExerciseModeRequest request);
}
