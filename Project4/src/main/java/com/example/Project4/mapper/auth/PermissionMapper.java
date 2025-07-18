package com.example.Project4.mapper.auth;

import com.example.Project4.dto.auth.response.*;
import com.example.Project4.dto.auth.request.*;
import com.example.Project4.entity.auth.*;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
    Permission toPermission(PermissionCreationRequest request);
    PermissionCreationResponse toPermissionResponse(Permission permission);
}
