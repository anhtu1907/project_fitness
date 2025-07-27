package aptech.finalproject.service;

import aptech.finalproject.dto.request.PermissionCreationRequest;
import aptech.finalproject.dto.response.PermissionCreationResponse;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.PermissionMapper;
import aptech.finalproject.repository.PermissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PermissionServiceImpl implements PermissionService {
    @Autowired
    private PermissionRepository permissionRepository;
    @Autowired
    private PermissionMapper permissionMapper;

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public PermissionCreationResponse create(PermissionCreationRequest request) {
        return permissionMapper.toPermissionResponse(permissionRepository.save(permissionMapper.toPermission(request)));
    }

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public PermissionCreationResponse update(PermissionCreationRequest request) {
        return permissionMapper.toPermissionResponse(permissionRepository.save(permissionMapper.toPermission(request)));
    }

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public void delete(long permissionId) {
        permissionRepository.deleteById(permissionId);
    }

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public List<PermissionCreationResponse> findAll() {
        return permissionRepository.findAll().stream().map(permissionMapper::toPermissionResponse).toList();
    }

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public boolean existed(String permission) {
        return permissionRepository.existsByPermission(permission);
    }

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public PermissionCreationResponse findById(long permissionId) {
        return permissionRepository.findById(permissionId)
                .map(permissionMapper::toPermissionResponse)
                .orElseThrow(()-> new ApiException(ErrorCode.PERMISSION_NOT_FOUND));
    }

    @PreAuthorize("hasAuthority('MANAGE_ROLES')")
    public PermissionCreationResponse findByPermission(String permission) {
        return permissionRepository.findByPermission(permission)
                .map(permissionMapper::toPermissionResponse)
                .orElseThrow(()-> new ApiException(ErrorCode.PERMISSION_NOT_FOUND));
    }
}
