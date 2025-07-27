package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.SupplementRequest;
import aptech.finalproject.dto.response.product.SupplementResponse;

import java.util.List;

public interface SupplementService {
    SupplementResponse createSupplement(SupplementRequest supplementRequest);

    SupplementResponse updateSupplement(Long id, SupplementRequest supplementRequest);

    void deleteSupplement(Long id);

    SupplementResponse getSupplementById(Long id);

    List<SupplementResponse> getAllSupplements();
}
