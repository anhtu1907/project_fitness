package aptech.finalproject.mapper.meal;

import aptech.finalproject.dto.request.meal.MealSubCategoryRequest;
import aptech.finalproject.dto.response.meal.MealSubCategoryResponse;
import aptech.finalproject.entity.meal.MealSubCategoryModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface MealSubCategoryMapper {

    @Mapping(target = "category.id", source = "categoryId")
    @Mapping(target = "subCategoryImage", ignore = true)
    MealSubCategoryModel toEntity(MealSubCategoryRequest request);

    @Mapping(target = "categoryId", source = "category.id")
    MealSubCategoryResponse toResponse(MealSubCategoryModel entity);

    @Mapping(target = "category.id", source = "categoryId")
    @Mapping(target = "subCategoryImage", ignore = true)
    void update(@MappingTarget MealSubCategoryModel entity, MealSubCategoryRequest request);
}

