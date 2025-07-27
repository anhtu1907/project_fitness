package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.product.SupplierRequest;
import aptech.finalproject.dto.response.product.SupplierResponse;
import aptech.finalproject.entity.product.Product;
import aptech.finalproject.entity.product.Supplier;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;
import java.util.stream.Collectors;

@Mapper( componentModel = "spring")
public interface SupplierMapper {
    @Mapping(source = "image.storedName", target = "image")
    @Mapping(source = "products", target = "products", qualifiedByName = "mapProductsToIds")
    SupplierResponse toSupplierResponse(Supplier supplier);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "products", ignore = true)
    Supplier toSupplier(SupplierRequest supplierRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "image", ignore = true)
    @Mapping(target = "products", ignore = true)
    void upDateSupplier(@MappingTarget Supplier supplier, SupplierRequest supplierRequest);

    @Named("mapProductsToIds")
    static List<Long> mapProductsToIds(List<Product> products) {
        if (products == null) return null;
        return products.stream().map(Product::getId).collect(Collectors.toList());
    }
}
