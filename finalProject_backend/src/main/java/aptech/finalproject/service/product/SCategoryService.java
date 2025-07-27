package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.SCategoryRequest;
import aptech.finalproject.dto.response.product.SCategoryResponse;

import java.util.List;

public interface SCategoryService {
    SCategoryResponse createSCategory(SCategoryRequest sCategoryRequest);

    SCategoryResponse updateSCategory(Long id,SCategoryRequest sCategoryRequest);

    void deleteSCategory(Long id);

    SCategoryResponse getSCategoryById( Long id);

    List<SCategoryResponse> getAllSCategory();
}
