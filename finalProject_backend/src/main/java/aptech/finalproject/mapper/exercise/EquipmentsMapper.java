package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.EquipmentsRequest;
import aptech.finalproject.dto.response.exercise.EquipmentsResponse;
import aptech.finalproject.entity.exercise.EquipmentsModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface EquipmentsMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "equipmentImage", ignore = true)
    EquipmentsModel toEntity(EquipmentsRequest request);

    EquipmentsResponse toResponse(EquipmentsModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "equipmentImage", ignore = true)
    void updateEntity(@MappingTarget EquipmentsModel entity, EquipmentsRequest request);
}