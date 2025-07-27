package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.ECategoryRequest;
import aptech.finalproject.dto.response.product.ECategoryResponse;
import aptech.finalproject.entity.product.ECategory;
import aptech.finalproject.entity.product.Equipment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface ECategoryMapper {

    @Mapping(target = "image", source = "image.storedName")
    @Mapping(target = "equipment", source = "equipment", qualifiedByName = "mapEquipmentListToIdList")
    ECategoryResponse toECategoryResponse(ECategory eCategory);


    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "equipment", ignore = true)
    ECategory toECategory(ECategoryRequest eCategoryRequest);


    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "equipment", ignore = true)
    void updateECategory(@MappingTarget ECategory eCategory, ECategoryRequest eCategoryRequest);

    @Named("mapEquipmentListToIdList")
    static List<Long> mapEquipmentListToIdList(List<Equipment> equipmentList) {
        if (equipmentList == null) return null;
        return equipmentList.stream()
                .map(Equipment::getId)
                .collect(Collectors.toList());
    }
}
