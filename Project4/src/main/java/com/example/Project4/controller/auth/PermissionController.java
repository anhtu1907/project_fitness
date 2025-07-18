package com.example.Project4.controller.auth;

import com.example.Project4.dto.auth.request.*;
import com.example.Project4.dto.auth.response.*;
import com.example.Project4.service.auth.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/identity/permission")
public class PermissionController {
     @Autowired
    private PermissionService permissionService;

    @PostMapping()
    public ApiResponse<?> create(@RequestBody PermissionCreationRequest request) {
        return ApiResponse.ok(permissionService.create(request));
    }

    @GetMapping()
    public ApiResponse<?> getAll() {
        return ApiResponse.ok(permissionService.findAll());
    }

    @PutMapping("/{permissionId}")
    public ApiResponse<?> update(@PathVariable String permissionId, @RequestBody PermissionCreationRequest request) {
        return ApiResponse.ok(permissionService.update(request));
    }
    @DeleteMapping("/{permissionId}")
    public ApiResponse<?> delete(@PathVariable long permissionId) {
        permissionService.delete(permissionId);
        return ApiResponse.ok("Permission " + permissionId + " deleted successfully");
    }

    @GetMapping("/{permissionId}")
    public ApiResponse<?> getById(@PathVariable long permissionId) {
        return ApiResponse.ok(permissionService.findById(permissionId));
    }
}
