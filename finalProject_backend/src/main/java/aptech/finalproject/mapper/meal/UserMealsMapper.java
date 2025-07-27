package aptech.finalproject.mapper.meal;

import aptech.finalproject.dto.request.meal.UserMealsRequest;
import aptech.finalproject.dto.response.meal.UserMealsResponse;
import aptech.finalproject.entity.meal.UserMealsModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface UserMealsMapper {

    @Mapping(target = "user.id", source = "userId")
    @Mapping(target = "meal.id", source = "mealId")
    UserMealsModel toEntity(UserMealsRequest request);

    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "mealId", source = "meal.id")
    UserMealsResponse toResponse(UserMealsModel entity);

    @Mapping(target = "user.id", source = "userId")
    @Mapping(target = "meal.id", source = "mealId")
    void update(@MappingTarget UserMealsModel entity, UserMealsRequest request);
}
