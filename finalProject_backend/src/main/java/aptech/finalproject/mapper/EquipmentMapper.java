package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.EquipmentRequest;
import aptech.finalproject.dto.response.product.EquipmentResponse;
import aptech.finalproject.entity.product.ECategory;
import aptech.finalproject.entity.product.Equipment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;
import java.util.stream.Collectors;

@Mapper( componentModel = "spring")
public interface EquipmentMapper {
    @Mapping(target = "categoryIds", source = "ecategories", qualifiedByName = "mapCategoryToIds")
    @Mapping(target = "productId", source = "product.id")
    EquipmentResponse toEquipmentResponse(Equipment equipment);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "ecategories", ignore = true)
    @Mapping(target = "product", ignore = true)
    Equipment toEquipment(EquipmentRequest equipmentRequest);


    @Mapping(target = "id", ignore = true)
    @Mapping(target = "ecategories", ignore = true)
    @Mapping(target = "product", ignore = true)
    void updateEquipment(@MappingTarget Equipment equipment, EquipmentRequest equipmentRequest);

    @Named("mapCategoryToIds")
    static List<Long> mapCategoryToIds(List<ECategory> categories) {
        if (categories == null) return null;
        return categories.stream()
                .map(ECategory::getId)
                .collect(Collectors.toList());
    }
}
