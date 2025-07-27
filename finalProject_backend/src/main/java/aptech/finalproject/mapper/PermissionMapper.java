package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.PermissionCreationRequest;
import aptech.finalproject.dto.response.PermissionCreationResponse;
import aptech.finalproject.entity.auth.Permission;

import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
    Permission toPermission(PermissionCreationRequest request);
    PermissionCreationResponse toPermissionResponse(Permission permission);
}
