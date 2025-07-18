package com.example.Project4.service.auth;

import com.example.Project4.dto.auth.request.RoleCreationRequest;
import com.example.Project4.dto.auth.response.RoleCreationResponse;

import java.util.List;

public interface RoleService {

   RoleCreationResponse create(RoleCreationRequest request);

    RoleCreationResponse update(RoleCreationRequest request);

    void delete(long permission);

    List<RoleCreationResponse> findAll();

    boolean existedRole(String role);

    RoleCreationResponse findById(long roleId);
}
