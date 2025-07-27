package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.SupplementRequest;
import aptech.finalproject.dto.response.product.SupplementResponse;
import aptech.finalproject.entity.product.SCategory;
import aptech.finalproject.entity.product.Supplement;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;
import java.util.stream.Collectors;

@Mapper( componentModel = "spring")
public interface SupplementMapper {
    @Mapping(target = "product", source = "product")
    @Mapping(target = "categoryIds", source = "scategories", qualifiedByName = "mapSCategoryListToIds")
    SupplementResponse toSupplementResponse(Supplement supplement);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "product", ignore = true)       // xử lý trong service
    @Mapping(target = "scategories", ignore = true)   // xử lý trong service
    Supplement toSupplement(SupplementRequest supplementRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "product", ignore = true)
    @Mapping(target = "scategories", ignore = true)
    void updateSupplement(@MappingTarget Supplement supplement, SupplementRequest supplementRequest);

    // Helper: List<SCategory> → List<Long>
    @Named("mapSCategoryListToIds")
    static List<Long> mapSCategoryListToIds(List<SCategory> categories) {
        if (categories == null) return null;
        return categories.stream()
                .map(SCategory::getId)
                .collect(Collectors.toList());
    }
}
