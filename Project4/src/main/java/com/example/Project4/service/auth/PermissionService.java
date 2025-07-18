package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.PermissionCreationRequest;
import com.example.Project4.dto.auth.response.PermissionCreationResponse;

import java.util.List;

public interface PermissionService {
    PermissionCreationResponse create(PermissionCreationRequest request);

    PermissionCreationResponse update(PermissionCreationRequest request);

    void delete(long permissionId);

    List<PermissionCreationResponse> findAll();

    boolean existed(String permission);

    PermissionCreationResponse findById(long permissionId);

    PermissionCreationResponse findByPermission(String permission);
}
