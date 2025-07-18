package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.example.Project4.exception.*;
import com.example.Project4.mapper.auth.*;
import com.example.Project4.repository.auth.*;
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

    @PreAuthorize("hasAuthority('ADMIN')")
    public PermissionCreationResponse create(PermissionCreationRequest request) {
        return permissionMapper.toPermissionResponse(permissionRepository.save(permissionMapper.toPermission(request)));
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public PermissionCreationResponse update(PermissionCreationRequest request) {
        return permissionMapper.toPermissionResponse(permissionRepository.save(permissionMapper.toPermission(request)));
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public void delete(long permissionId) {
        permissionRepository.deleteById(permissionId);
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public List<PermissionCreationResponse> findAll() {
        return permissionRepository.findAll().stream().map(permissionMapper::toPermissionResponse).toList();
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public boolean existed(String permission) {
        return permissionRepository.existsByPermission(permission);
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public PermissionCreationResponse findById(long permissionId) {
        return permissionRepository.findById(permissionId)
                .map(permissionMapper::toPermissionResponse)
                .orElseThrow(()-> new ApiException(ErrorCode.PERMISSION_NOT_FOUND));
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    public PermissionCreationResponse findByPermission(String permission) {
        return permissionRepository.findByPermission(permission)
                .map(permissionMapper::toPermissionResponse)
                .orElseThrow(()-> new ApiException(ErrorCode.PERMISSION_NOT_FOUND));
    }
}
