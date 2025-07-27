package aptech.finalproject.mapper.exercise;

import aptech.finalproject.dto.request.exercise.ExerciseSubCategoryProgramRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSubCategoryProgramResponse;
import aptech.finalproject.entity.exercise.ExerciseProgramsModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryProgramModel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ExerciseSubCategoryProgramMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    @Mapping(target = "program", expression = "java(toProgram(request.getProgramId()))")
    ExerciseSubCategoryProgramModel toEntity(ExerciseSubCategoryProgramRequest request);

    @Mapping(source = "subCategory.id", target = "subCategoryId")
    @Mapping(source = "program.id", target = "programId")
    ExerciseSubCategoryProgramResponse toResponse(ExerciseSubCategoryProgramModel entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "subCategory", expression = "java(toSubCategory(request.getSubCategoryId()))")
    @Mapping(target = "program", expression = "java(toProgram(request.getProgramId()))")
    void updateEntity(@MappingTarget ExerciseSubCategoryProgramModel entity, ExerciseSubCategoryProgramRequest request);

    // ===== Helper methods =====
    default ExerciseSubCategoryModel toSubCategory(Integer id) {
        if (id == null) return null;
        ExerciseSubCategoryModel sub = new ExerciseSubCategoryModel();
        sub.setId(id);
        return sub;
    }

    default ExerciseProgramsModel toProgram(Integer id) {
        if (id == null) return null;
        ExerciseProgramsModel program = new ExerciseProgramsModel();
        program.setId(id);
        return program;
    }
}

