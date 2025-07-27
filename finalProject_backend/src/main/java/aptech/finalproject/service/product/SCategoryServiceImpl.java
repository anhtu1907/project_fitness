package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.SCategoryRequest;
import aptech.finalproject.dto.response.product.SCategoryResponse;
import aptech.finalproject.entity.product.SCategory;
import aptech.finalproject.entity.product.Supplement;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.SCategoryMapper;
import aptech.finalproject.repository.product.SCategoryRepository;
import aptech.finalproject.repository.product.SupplementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SCategoryServiceImpl implements SCategoryService{
    @Autowired
    private SCategoryRepository sCategoryRepository;

    @Autowired
    private SCategoryMapper sCategoryMapper;

    @Autowired
    private SupplementRepository supplementRepository;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public SCategoryResponse createSCategory(SCategoryRequest sCategoryRequest) {
        SCategory sCategory = sCategoryMapper.toSCategory(sCategoryRequest);

        if (sCategoryRequest.getSupplementIds() != null && !sCategoryRequest.getSupplementIds().isEmpty()) {
            List<Supplement> supplements = supplementRepository.findAllById(sCategoryRequest.getSupplementIds());
            sCategory.setSupplements(supplements);
        }

        return sCategoryMapper.toSCategoryResponse(sCategoryRepository.save(sCategory));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    @Transactional
    public SCategoryResponse updateSCategory(Long id, SCategoryRequest sCategoryRequest) {
        SCategory sCategory = sCategoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.SCATEGORY_NOT_FOUND));

        sCategoryMapper.updateSCategory(sCategory, sCategoryRequest);

        if (sCategoryRequest.getSupplementIds() != null) {
            List<Supplement> supplements = supplementRepository.findAllById(sCategoryRequest.getSupplementIds());
            sCategory.setSupplements(supplements);
        }

        return sCategoryMapper.toSCategoryResponse(sCategoryRepository.save(sCategory));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteSCategory(Long id) {
        if (!sCategoryRepository.existsById(id)) {
            throw new ApiException(ErrorCode.SCATEGORY_NOT_FOUND);
        }
        sCategoryRepository.deleteById(id);
    }

    public SCategoryResponse getSCategoryById(Long id) {
        SCategory sCategory = sCategoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.SCATEGORY_NOT_FOUND));
        return sCategoryMapper.toSCategoryResponse(sCategory);
    }

    public List<SCategoryResponse> getAllSCategory() {
        return sCategoryRepository.findAll()
                .stream()
                .map(sCategoryMapper::toSCategoryResponse)
                .collect(Collectors.toList());
    }

}
