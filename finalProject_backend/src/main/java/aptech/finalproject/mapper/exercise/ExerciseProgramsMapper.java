package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseProgramsRequest;
import aptech.finalproject.dto.response.exercise.ExerciseProgramsResponse;
import aptech.finalproject.entity.exercise.ExerciseProgramsModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseProgramsMapper {

    @Mapping(target = "id", ignore = true)
    ExerciseProgramsModel toEntity(ExerciseProgramsRequest request);

    ExerciseProgramsResponse toResponse(ExerciseProgramsModel entity);

    @Mapping(target = "id", ignore = true)
    void updateEntity(@MappingTarget ExerciseProgramsModel entity, ExerciseProgramsRequest request);
}
