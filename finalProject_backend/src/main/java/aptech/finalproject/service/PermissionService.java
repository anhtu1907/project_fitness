package aptech.finalproject.service;

import aptech.finalproject.dto.request.PermissionCreationRequest;
import aptech.finalproject.dto.response.PermissionCreationResponse;

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
