package aptech.finalproject.dto.response;

import aptech.finalproject.entity.auth.Permission;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RolePermissionResponse {
    private Long id;
    private String role;
    private Set<Permission> permissions;
    private String description;
}
