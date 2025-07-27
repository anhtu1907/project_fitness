package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.EquipmentRequest;
import aptech.finalproject.dto.response.product.EquipmentResponse;
import aptech.finalproject.entity.product.ECategory;
import aptech.finalproject.entity.product.Equipment;
import aptech.finalproject.entity.product.Product;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.EquipmentMapper;
import aptech.finalproject.repository.product.ECategoryRepository;
import aptech.finalproject.repository.product.EquipmentRepository;
import aptech.finalproject.repository.product.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EquipmentServiceImpl implements EquipmentService{
    @Autowired
    private EquipmentRepository equipmentRepository;

    @Autowired
    private EquipmentMapper equipmentMapper;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ECategoryRepository eCategoryRepository;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public EquipmentResponse createEquipment(EquipmentRequest equipmentRequest) {
        Equipment equipment = equipmentMapper.toEquipment(equipmentRequest);

        Product product = productRepository.findById(equipmentRequest.getProductId())
                .orElseThrow(() -> new ApiException(ErrorCode.PRODUCT_NOT_FOUND));
        equipment.setProduct(product);

        if (equipmentRequest.getCategoryIds() != null && !equipmentRequest.getCategoryIds().isEmpty()) {
            List<ECategory> categories = eCategoryRepository.findAllById(equipmentRequest.getCategoryIds());
            equipment.setEcategories(categories);
        }

        product.setType("supplement");
        productRepository.save(product);
        return equipmentMapper.toEquipmentResponse(equipmentRepository.save(equipment));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public EquipmentResponse updateEquipment(Long id, EquipmentRequest equipmentRequest) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));

        equipmentMapper.updateEquipment(equipment, equipmentRequest);

        Product product = productRepository.findById(equipmentRequest.getProductId())
                .orElseThrow(() -> new ApiException(ErrorCode.PRODUCT_NOT_FOUND));
        equipment.setProduct(product);

        if (equipmentRequest.getCategoryIds() != null) {
            List<ECategory> categories = eCategoryRepository.findAllById(equipmentRequest.getCategoryIds());
            equipment.setEcategories(categories);
        }

        return equipmentMapper.toEquipmentResponse(equipmentRepository.save(equipment));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteEquipment(Long id) {
        if (!equipmentRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND);
        }
        equipmentRepository.deleteById(id);
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public EquipmentResponse getEquipmentById(Long id) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));
        return equipmentMapper.toEquipmentResponse(equipment);
    }

    public List<EquipmentResponse> getAllEquipments(Pageable pageable) {
        return equipmentRepository.findAll(pageable)
                .stream()
                .map(equipmentMapper::toEquipmentResponse)
                .collect(Collectors.toList());
    }
}
