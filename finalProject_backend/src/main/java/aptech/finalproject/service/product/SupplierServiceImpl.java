package aptech.finalproject.service.product;

import aptech.finalproject.dto.request.product.SupplierRequest;
import aptech.finalproject.dto.response.product.SupplierResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.product.Supplier;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.SupplierMapper;
import aptech.finalproject.repository.product.SupplierRepository;
import aptech.finalproject.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SupplierServiceImpl implements SupplierService{
    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private SupplierMapper supplierMapper;

    @Autowired
    private FileService fileService;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public SupplierResponse createSupplier(SupplierRequest supplierRequest) {
        Supplier supplier = supplierMapper.toSupplier(supplierRequest);

        if (supplierRequest.getImage() != null && !supplierRequest.getImage().isEmpty()) {
            FileMetadata image = fileService.saveFile(supplierRequest.getImage(), Optional.of("supplier"));
            supplier.setImage(image);
        }

        return supplierMapper.toSupplierResponse(supplierRepository.save(supplier));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public SupplierResponse updateSupplier(Long id, SupplierRequest supplierRequest) {
        Supplier supplier = supplierRepository.findById(id).orElseThrow(
                () -> new ApiException(ErrorCode.SUPPLIER_NOT_FOUND)
        );

        supplierMapper.upDateSupplier(supplier, supplierRequest);

        if (supplierRequest.getImage() != null && !supplierRequest.getImage().isEmpty()) {
            FileMetadata image = fileService.saveFile(supplierRequest.getImage(), Optional.of("supplier"));
            supplier.setImage(image);
        }

        return supplierMapper.toSupplierResponse(supplierRepository.save(supplier));
    }


    public List<SupplierResponse> getAllSuppliers() {
        return supplierRepository.findAll()
                .stream()
                .map(supplierMapper::toSupplierResponse)
                .collect(Collectors.toList());
    }


    public SupplierResponse getById(Long id) {
        Supplier supplier = supplierRepository.findById(id).orElseThrow(
                () -> new ApiException(ErrorCode.SUPPLIER_NOT_FOUND)
        );
        return supplierMapper.toSupplierResponse(supplier);
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteById(Long id) {
        if (!supplierRepository.existsById(id)) {
            throw new ApiException(ErrorCode.SUPPLIER_NOT_FOUND);
        }
        supplierRepository.deleteById(id);
    }

}
