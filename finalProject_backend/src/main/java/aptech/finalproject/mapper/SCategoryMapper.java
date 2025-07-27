package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.SCategoryRequest;
import aptech.finalproject.dto.response.product.SCategoryResponse;
import aptech.finalproject.entity.product.SCategory;
import aptech.finalproject.entity.product.Supplement;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;
import java.util.stream.Collectors;

@Mapper( componentModel = "spring")
public interface SCategoryMapper {
    @Mapping(target = "supplements", source = "supplements", qualifiedByName = "mapSupplementListToIdList")
    SCategoryResponse toSCategoryResponse(SCategory sCategory);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "supplements", ignore = true)
    SCategory toSCategory(SCategoryRequest sCategoryRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "supplements", ignore = true)
    void updateSCategory(@MappingTarget SCategory sCategory, SCategoryRequest sCategoryRequest);

    @Named("mapSupplementListToIdList")
    static List<Long> mapSupplementListToIdList(List<Supplement> supplements) {
        if (supplements == null) return null;
        return supplements.stream()
                .map(Supplement::getId)
                .collect(Collectors.toList());
    }
}
