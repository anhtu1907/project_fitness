package aptech.finalproject.service;

import aptech.finalproject.dto.request.RoleCreationRequest;
import aptech.finalproject.dto.response.RoleCreationResponse;
import aptech.finalproject.dto.response.RolePermissionResponse;
import aptech.finalproject.entity.auth.Permission;
import aptech.finalproject.exception.ApiException;

import javax.management.relation.RoleNotFoundException;
import java.util.List;
import java.util.Set;

public interface RoleService {

    RoleCreationResponse create(RoleCreationRequest request);

    RoleCreationResponse update(RoleCreationRequest request);

    void delete(long permission);

    List<RolePermissionResponse> findAll();

    boolean existedRole(String role);

    RoleCreationResponse findById(long roleId);

    RolePermissionResponse updateRolePermissions(Long roleId, Set<Long> permissions) throws ApiException;
}
