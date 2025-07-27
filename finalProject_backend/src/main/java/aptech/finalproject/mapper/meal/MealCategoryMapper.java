package aptech.finalproject.mapper.meal;

import aptech.finalproject.dto.request.meal.MealCategoryRequest;
import aptech.finalproject.dto.response.meal.MealCategoryResponse;
import aptech.finalproject.entity.meal.MealCategoryModel;
import aptech.finalproject.entity.meal.MealSubCategoryModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface MealCategoryMapper {
    @Mapping(target = "subCategory", ignore = true)
    @Mapping( target = "categoryImage", ignore = true)
    MealCategoryModel toEntity(MealCategoryRequest request);

    @Mapping(target = "subCategoryIds", expression = "java(mapSubCategoryIds(entity.getSubCategory()))")
    MealCategoryResponse toResponse(MealCategoryModel entity);

    @Mapping(target = "subCategory", ignore = true)
    @Mapping( target = "categoryImage", ignore = true)
    void update(@MappingTarget MealCategoryModel entity, MealCategoryRequest request);

    default List<Integer> mapSubCategoryIds(List<MealSubCategoryModel> subCategories) {
        if (subCategories == null) return List.of();
        return subCategories.stream()
                .map(MealSubCategoryModel::getId)
                .collect(Collectors.toList());
    }
}



