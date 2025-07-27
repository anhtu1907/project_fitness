package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseProgressRequest;
import aptech.finalproject.dto.response.exercise.ExerciseProgressResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.exercise.ExerciseProgressModel;
import aptech.finalproject.entity.exercise.ExerciseSessionModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseProgressMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "exercise", expression = "java(toSession(request.getSessionId()))")
    @Mapping(target = "lastUpdated", ignore = true)
    ExerciseProgressModel toEntity(ExerciseProgressRequest request);

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "exercise.id", target = "sessionId")
    ExerciseProgressResponse toResponse(ExerciseProgressModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", expression = "java(toUser(request.getUserId()))")
    @Mapping(target = "exercise", expression = "java(toSession(request.getSessionId()))")
    @Mapping(target = "lastUpdated", ignore = true)
    void updateEntity(@MappingTarget ExerciseProgressModel entity, ExerciseProgressRequest request);

    // Helper methods to create minimal user and session entities by ID
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