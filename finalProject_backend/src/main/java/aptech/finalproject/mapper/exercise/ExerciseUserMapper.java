package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseUserRequest;
import aptech.finalproject.dto.response.exercise.ExerciseUserResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.exercise.ExerciseSessionModel;
import aptech.finalproject.entity.exercise.ExerciseUserModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseUserMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "session", expression = "java(toSession(request.getSessionId()))")
    ExerciseUserModel toEntity(ExerciseUserRequest request);

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "session.id", target = "sessionId")
    ExerciseUserResponse toResponse(ExerciseUserModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "session", expression = "java(toSession(request.getSessionId()))")
    void updateEntity(@MappingTarget ExerciseUserModel entity, ExerciseUserRequest request);

    // ===== Helper methods =====
    default User toUser(String id) {
        if (id == null) return null;
        User user = new User();
        user.setId(id);
        return user;
    }

    default ExerciseSessionModel toSession(Integer id) {
        if (id == null) return null;
        ExerciseSessionModel session = new ExerciseSessionModel();
        session.setId(id);
        return session;
    }
}

