package aptech.finalproject.mapper.meal;

import aptech.finalproject.dto.request.meal.MealsRequest;
import aptech.finalproject.dto.response.meal.MealsResponse;
import aptech.finalproject.entity.meal.MealSubCategoryModel;
import aptech.finalproject.entity.meal.MealTimeModel;
import aptech.finalproject.entity.meal.MealsModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface MealsMapper {

    @Mapping(target = "subCategory", ignore = true)
    @Mapping(target = "timeOfDay", ignore = true)
    @Mapping(target = "mealImage", ignore = true)
    MealsModel toEntity(MealsRequest request);

    @Mapping(target = "subCategoryIds", expression = "java(mapSubCategoryIds(entity.getSubCategory()))")
    @Mapping(target = "timeOfDayIds", expression = "java(mapTimeOfDayIds(entity.getTimeOfDay()))")
    MealsResponse toResponse(MealsModel entity);

    @Mapping(target = "subCategory", ignore = true)
    @Mapping(target = "timeOfDay", ignore = true)
    @Mapping(target = "mealImage", ignore = true)
    void update(@MappingTarget MealsModel entity, MealsRequest request);

    default Set<Integer> mapSubCategoryIds(Set<MealSubCategoryModel> subs) {
        return subs == null ? Set.of() :
                subs.stream().map(MealSubCategoryModel::getId).collect(Collectors.toSet());
    }

    default Set<Integer> mapTimeOfDayIds(Set<MealTimeModel> times) {
        return times == null ? Set.of() :
                times.stream().map(MealTimeModel::getId).collect(Collectors.toSet());
    }
}

