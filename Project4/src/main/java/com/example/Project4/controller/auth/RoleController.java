package com.example.Project4.controller.auth;

import com.example.Project4.dto.auth.request.RoleCreationRequest;
import com.example.Project4.dto.auth.response.ApiResponse;
import com.example.Project4.service.auth.RoleService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/identity/role")
public class RoleController {
    @Autowired
    private RoleService roleService;

    @PostMapping()
    public ApiResponse<?> create(@RequestBody RoleCreationRequest request) {
        return ApiResponse.ok(roleService.create(request));
    }

    @GetMapping()
    public ApiResponse<?> getAll() {
        return ApiResponse.ok(roleService.findAll());
    }

    @PutMapping("/{role}")
    public ApiResponse<?> update(@PathVariable  String role, @RequestBody RoleCreationRequest request) {
        if(roleService.existedRole(role)){
            return ApiResponse.ok(roleService.update(request));
        }
        return ApiResponse.badRequest("Role not found");
    }

    @GetMapping("/{roleId}")
    public ApiResponse<?> getById(@PathVariable long roleId) {
        return ApiResponse.ok(roleService.findById(roleId));
    }

    @DeleteMapping("/{roleId}")
    public ApiResponse<?> delete(@PathVariable long roleId) {
        roleService.delete(roleId);
        return ApiResponse.ok("Role " + roleId + " deleted successfully");
    }
}
