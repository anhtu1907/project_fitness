package aptech.finalproject.mapper.meal;

import aptech.finalproject.dto.request.meal.MealTimeRequest;
import aptech.finalproject.dto.response.meal.MealTimeResponse;
import aptech.finalproject.entity.meal.MealTimeModel;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface MealTimeMapper {
    MealTimeModel toEntity(MealTimeRequest request);

    MealTimeResponse toResponse(MealTimeModel entity);

    void update(@MappingTarget MealTimeModel entity, MealTimeRequest request);
}