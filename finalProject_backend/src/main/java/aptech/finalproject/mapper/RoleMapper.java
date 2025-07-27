package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.RoleCreationRequest;
import aptech.finalproject.dto.response.RoleCreationResponse;
import aptech.finalproject.dto.response.RolePermissionResponse;
import aptech.finalproject.entity.auth.Role;

import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface RoleMapper {
    Role toRole(RoleCreationRequest request);
    RoleCreationResponse toRoleResponse(Role role);
    RolePermissionResponse toRolePermisionPesponse(Role role);
}
