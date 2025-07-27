package aptech.finalproject.mapper;

import aptech.finalproject.dto.request.UserCreationRequest;
import aptech.finalproject.dto.request.UserUpdateRequest;
import aptech.finalproject.dto.response.UserResponse;
import aptech.finalproject.entity.auth.User;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User toUser(UserCreationRequest request);

    void updateUser(@MappingTarget User user, UserUpdateRequest request);

    UserResponse toUserResponse(User user);
}
