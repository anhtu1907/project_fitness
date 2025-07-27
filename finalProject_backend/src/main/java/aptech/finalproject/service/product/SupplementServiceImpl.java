package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.SupplementRequest;
import aptech.finalproject.dto.response.product.SupplementResponse;
import aptech.finalproject.entity.product.Product;
import aptech.finalproject.entity.product.SCategory;
import aptech.finalproject.entity.product.Supplement;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.SupplementMapper;
import aptech.finalproject.repository.product.ProductRepository;
import aptech.finalproject.repository.product.SCategoryRepository;
import aptech.finalproject.repository.product.SupplementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SupplementServiceImpl implements SupplementService {
    @Autowired
    private SupplementRepository supplementRepository;

    @Autowired
    private SupplementMapper supplementMapper;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private SCategoryRepository sCategoryRepository;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public SupplementResponse createSupplement(SupplementRequest supplementRequest) {
        Supplement supplement = supplementMapper.toSupplement(supplementRequest);

        Product product = productRepository.findById(supplementRequest.getProductId())
                .orElseThrow(() -> new ApiException(ErrorCode.PRODUCT_NOT_FOUND));
        supplement.setProduct(product);

        if (supplementRequest.getScategoryIds() != null && !supplementRequest.getScategoryIds().isEmpty()) {
            List<SCategory> sCategories = sCategoryRepository.findAllById(supplementRequest.getScategoryIds());
            supplement.setScategories(sCategories);
        }
        product.setType("equipment");
        productRepository.save(product);
        return supplementMapper.toSupplementResponse(supplementRepository.save(supplement));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public SupplementResponse updateSupplement(Long id, SupplementRequest supplementRequest) {
        Supplement supplement = supplementRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.SUPPLEMENT_NOT_FOUND));

        supplementMapper.updateSupplement(supplement, supplementRequest);

        Product product = productRepository.findById(supplementRequest.getProductId())
                .orElseThrow(() -> new ApiException(ErrorCode.PRODUCT_NOT_FOUND));
        supplement.setProduct(product);

        if (supplementRequest.getScategoryIds() != null) {
            List<SCategory> sCategories = sCategoryRepository.findAllById(supplementRequest.getScategoryIds());
            supplement.setScategories(sCategories);
        }

        return supplementMapper.toSupplementResponse(supplementRepository.save(supplement));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteSupplement(Long id) {
        if (!supplementRepository.existsById(id)) {
            throw new ApiException(ErrorCode.SUPPLEMENT_NOT_FOUND);
        }
        supplementRepository.deleteById(id);
    }

    public SupplementResponse getSupplementById(Long id) {
        Supplement supplement = supplementRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.SUPPLEMENT_NOT_FOUND));
        return supplementMapper.toSupplementResponse(supplement);
    }

    public List<SupplementResponse> getAllSupplements() {
        return supplementRepository.findAll()
                .stream()
                .map(supplementMapper::toSupplementResponse)
                .collect(Collectors.toList());
    }
}
