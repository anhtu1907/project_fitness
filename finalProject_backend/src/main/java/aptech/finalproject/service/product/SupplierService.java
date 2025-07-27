package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.SupplierRequest;
import aptech.finalproject.dto.response.product.SupplierResponse;

import java.util.List;

public interface SupplierService {

    SupplierResponse createSupplier(SupplierRequest supplierRequest);

    List<SupplierResponse> getAllSuppliers();

    SupplierResponse getById(Long id);

    void deleteById(Long id);

    SupplierResponse updateSupplier(Long id,SupplierRequest supplierRequest);
}
