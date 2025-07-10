package com.example.Project4.mapper;

import java.util.Set;
import java.util.stream.Collectors;

import com.example.Project4.dto.exercise.EquipmentsDTO;
import com.example.Project4.dto.exercise.ExerciseCategoryDTO;
import com.example.Project4.dto.exercise.ExerciseFavoriteDTO;
import com.example.Project4.dto.exercise.ExerciseModeDTO;
import com.example.Project4.dto.exercise.ExerciseProgramsDTO;
import com.example.Project4.dto.exercise.ExerciseProgressDTO;
import com.example.Project4.dto.exercise.ExerciseScheduleDTO;
import com.example.Project4.dto.exercise.ExerciseSessionDTO;
import com.example.Project4.dto.exercise.ExerciseSubCategoryDTO;
import com.example.Project4.dto.exercise.ExerciseSubCategoryProgramDTO;
import com.example.Project4.dto.exercise.ExerciseUserDTO;
import com.example.Project4.dto.exercise.ExercisesDTO;
import com.example.Project4.dto.exercise.FavoritesDTO;
import com.example.Project4.dto.meal.UserSimpleDTO;
import com.example.Project4.models.exercise.EquipmentsModel;
import com.example.Project4.models.exercise.ExerciseCategoryModel;
import com.example.Project4.models.exercise.ExerciseFavoriteModel;
import com.example.Project4.models.exercise.ExerciseProgramsModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
import com.example.Project4.models.exercise.ExerciseSessionModel;
import com.example.Project4.models.exercise.ExerciseSubCategoryModel;
import com.example.Project4.models.exercise.ExerciseSubCategoryProgramModel;
import com.example.Project4.models.exercise.ExerciseUserModel;
import com.example.Project4.models.exercise.ExercisesModel;
import com.example.Project4.models.exercise.FavoritesModel;

public class ExerciseMapper {
        public static ExercisesDTO toDto(ExercisesModel entity) {
                ExercisesDTO dto = new ExercisesDTO();
                dto.setId(entity.getId());
                dto.setExerciseName(entity.getExerciseName());
                dto.setExerciseImage(entity.getExerciseImage());
                dto.setDescription(entity.getDescription());
                dto.setDuration(entity.getDuration());
                dto.setKcal(entity.getKcal());

                Set<ExerciseSubCategoryDTO> subCategoryDtos = entity.getSubCategory()
                                .stream()
                                .map(ExerciseMapper::toSubCategoryDto)
                                .collect(Collectors.toSet());
                dto.setSubCategory(subCategoryDtos);

                dto.setEquipment(entity.getEquipment() != null
                                ? new EquipmentsDTO(
                                                entity.getEquipment().getId(),
                                                entity.getEquipment().getEquipmentName(),
                                                entity.getEquipment().getEquipmentImage())
                                : null);

                dto.setMode(entity.getMode() != null
                                ? new ExerciseModeDTO(
                                                entity.getMode().getId(),
                                                entity.getMode().getModeName())
                                : null);

                return dto;
        }

        public static ExercisesDTO toDto(ExercisesModel entity, int subCategoryId) {
                ExercisesDTO dto = new ExercisesDTO();
                dto.setId(entity.getId());
                dto.setExerciseName(entity.getExerciseName());
                dto.setExerciseImage(entity.getExerciseImage());
                dto.setDescription(entity.getDescription());
                dto.setDuration(entity.getDuration());
                dto.setKcal(entity.getKcal());

                Set<ExerciseSubCategoryDTO> subCategoryDtos = entity.getSubCategory()
                                .stream()
                                .filter(sub -> sub.getId() == subCategoryId)
                                .map(ExerciseMapper::toSubCategoryDto)
                                .collect(Collectors.toSet());
                dto.setSubCategory(subCategoryDtos);

                dto.setEquipment(entity.getEquipment() != null
                                ? new EquipmentsDTO(
                                                entity.getEquipment().getId(),
                                                entity.getEquipment().getEquipmentName(),
                                                entity.getEquipment().getEquipmentImage())
                                : null);

                dto.setMode(entity.getMode() != null
                                ? new ExerciseModeDTO(
                                                entity.getMode().getId(),
                                                entity.getMode().getModeName())
                                : null);

                return dto;
        }

        public static ExerciseSubCategoryDTO toSubCategoryDto(ExerciseSubCategoryModel entity) {
                if (entity == null) {
                        return null;
                }

                Set<ExerciseCategoryDTO> categoryDtos = entity.getCategory()
                                .stream()
                                .map(ExerciseMapper::toCategoryDto)
                                .collect(Collectors.toSet());

                return new ExerciseSubCategoryDTO(
                                entity.getId(),
                                entity.getSubCategoryName(),
                                entity.getSubCategoryImage(),
                                entity.getDescription(),
                                categoryDtos);
        }

        public static ExerciseCategoryDTO toCategoryDto(ExerciseCategoryModel entity) {
                if (entity == null)
                        return null;

                return new ExerciseCategoryDTO(
                                entity.getId(),
                                entity.getCategoryName(),
                                entity.getCategoryImage());
        }

        public static ExerciseProgramsDTO toProgramDto(ExerciseProgramsModel entity) {
                if (entity == null) {
                        return null;
                }
                return new ExerciseProgramsDTO(
                                entity.getId(),
                                entity.getProgramName());
        }

        public static ExerciseSubCategoryProgramDTO toSubCategoryProgramDto(ExerciseSubCategoryProgramModel entity) {
                if (entity == null) {
                        return null;
                }

                ExerciseSubCategoryDTO subCategoryDto = ExerciseMapper.toSubCategoryDto(entity.getSubCategory());
                ExerciseProgramsDTO programDto = ExerciseMapper.toProgramDto(entity.getProgram());

                return new ExerciseSubCategoryProgramDTO(
                                entity.getId(),
                                subCategoryDto,
                                programDto);
        }

        public static ExerciseFavoriteDTO toExerciseFavoriteDTO(ExerciseFavoriteModel entity) {
                if (entity == null) {
                        return null;
                }

                UserSimpleDTO userDto = null;
                if (entity.getUser() != null) {
                        userDto = new UserSimpleDTO(
                                        entity.getUser().getId(),
                                        entity.getUser().getFirstname(),
                                        entity.getUser().getLastname());
                }

                FavoritesDTO favoriteDto = null;
                if (entity.getFavorite() != null) {
                        favoriteDto = ExerciseMapper.toFavoritesDto(entity.getFavorite());
                }

                ExerciseSubCategoryDTO subCategoryDTO = null;
                if (entity.getSubCategory() != null) {
                        subCategoryDTO = ExerciseMapper.toSubCategoryDto(entity.getSubCategory());
                }

                return new ExerciseFavoriteDTO(entity.getId(), userDto, favoriteDto, subCategoryDTO);
        }

        public static FavoritesDTO toFavoritesDto(FavoritesModel entity) {
                if (entity == null) {
                        return null;
                }
                UserSimpleDTO userDto = null;
                if (entity.getUser() != null) {
                        userDto = new UserSimpleDTO(entity.getUser().getId(), entity.getUser().getFirstname(),
                                        entity.getUser().getLastname());
                }
                return new FavoritesDTO(entity.getId(), entity.getFavoriteName(), userDto);
        }

        public static ExerciseSessionDTO toSessionDto(ExerciseSessionModel entity) {
                if (entity == null)
                        return null;

                UserSimpleDTO userDto = null;
                if (entity.getUser() != null) {
                        userDto = new UserSimpleDTO(
                                        entity.getUser().getId(),
                                        entity.getUser().getFirstname(),
                                        entity.getUser().getLastname());
                }

                ExercisesDTO exerciseDto = null;
                if (entity.getExercise() != null) {
                        exerciseDto = toDto(entity.getExercise());
                }

                ExerciseSubCategoryDTO subCategoryDto = null;
                if (entity.getSubCategory() != null) {
                        subCategoryDto = toSubCategoryDto(entity.getSubCategory());
                }

                return new ExerciseSessionDTO(
                                entity.getId(),
                                userDto,
                                exerciseDto,
                                subCategoryDto,
                                entity.getKcal(),
                                entity.getResetBatch(),
                                entity.getDuration(),
                                entity.getCreatedAt());
        }

        public static ExerciseUserDTO toExerciseUserDto(ExerciseUserModel entity) {
                if (entity == null)
                        return null;

                UserSimpleDTO userDto = null;
                if (entity.getUser() != null) {
                        userDto = new UserSimpleDTO(
                                        entity.getUser().getId(),
                                        entity.getUser().getFirstname(),
                                        entity.getUser().getLastname());
                }

                ExerciseSessionDTO sessionDto = null;
                if (entity.getSession() != null) {
                        sessionDto = toSessionDto(entity.getSession());
                }

                return new ExerciseUserDTO(
                                entity.getId(),
                                userDto,
                                sessionDto,
                                entity.getKcal(),
                                entity.getCreatedAt());
        }

        public static ExerciseProgressDTO toExerciseProgressDto(ExerciseProgressModel entity) {
                if (entity == null)
                        return null;

                UserSimpleDTO userDto = null;
                if (entity.getUser() != null) {
                        userDto = new UserSimpleDTO(
                                        entity.getUser().getId(),
                                        entity.getUser().getFirstname(),
                                        entity.getUser().getLastname());
                }

                ExerciseSessionDTO sessionDto = null;
                if (entity.getExercise() != null) {
                        sessionDto = toSessionDto(entity.getExercise());
                }

                return new ExerciseProgressDTO(
                                entity.getId(),
                                userDto,
                                sessionDto,
                                entity.getProgress(),
                                entity.getLastUpdated());
        }

        public static ExerciseScheduleDTO toScheduleDto(ExerciseScheduleModel entity) {
                if (entity == null) {
                        return null;
                }

                UserSimpleDTO userDto = null;
                if (entity.getUser() != null) {
                        userDto = new UserSimpleDTO(
                                        entity.getUser().getId(),
                                        entity.getUser().getFirstname(),
                                        entity.getUser().getLastname());
                }

                ExerciseSubCategoryDTO subCategoryDto = null;
                if (entity.getSubCategory() != null) {
                        subCategoryDto = ExerciseMapper.toSubCategoryDto(entity.getSubCategory());
                }

                return new ExerciseScheduleDTO(
                                entity.getId(),
                                userDto,
                                subCategoryDto,
                                entity.getScheduleTime());
        }

        public static EquipmentsDTO toEquipmentsDto(EquipmentsModel entity){
                if(entity == null){
                        return null;
                }
                return new EquipmentsDTO(entity.getId(), entity.getEquipmentName(), entity.getEquipmentImage());
        }

        
}
