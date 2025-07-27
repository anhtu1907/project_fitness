package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.CategoryRequest;
import aptech.finalproject.dto.response.product.CategoryResponse;
import aptech.finalproject.entity.product.Category;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper( componentModel = "spring")
public interface CategoryMapper {

    @Mapping(target = "id", source = "id")
    @Mapping(target = "name", source = "name")
    @Mapping(target = "description", source = "description")
    CategoryResponse toCategoryResponse(Category category);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "products", ignore = true)
    Category toCategory(CategoryRequest categoryRequest);


    @Mapping(target = "products", ignore = true)
    @Mapping(target = "id", ignore = true)
    void updateCategory(@MappingTarget Category category, CategoryRequest categoryRequest);
}
