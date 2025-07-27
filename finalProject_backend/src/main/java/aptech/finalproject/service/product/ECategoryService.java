package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.ECategoryRequest;
import aptech.finalproject.dto.response.product.ECategoryResponse;

import java.util.List;

public interface ECategoryService{
    ECategoryResponse createECategory(ECategoryRequest eCategoryRequest);

    ECategoryResponse updateECategory(Long id, ECategoryRequest eCategoryRequest);

    void deleteECategory(Long id);

    List<ECategoryResponse> getAllCategories();

    ECategoryResponse getCategoryById(Long id);
}
