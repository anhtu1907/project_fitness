package aptech.finalproject.mapper;

import java.util.Set;
import java.util.stream.Collectors;

import aptech.finalproject.dto.exercise.EquipmentsDTO;
import aptech.finalproject.dto.exercise.ExerciseCategoryDTO;
import aptech.finalproject.dto.exercise.ExerciseFavoriteDTO;
import aptech.finalproject.dto.exercise.ExerciseModeDTO;
import aptech.finalproject.dto.exercise.ExerciseProgramsDTO;
import aptech.finalproject.dto.exercise.ExerciseProgressDTO;
import aptech.finalproject.dto.exercise.ExerciseScheduleDTO;
import aptech.finalproject.dto.exercise.ExerciseSessionDTO;
import aptech.finalproject.dto.exercise.ExerciseSubCategoryDTO;
import aptech.finalproject.dto.exercise.ExerciseSubCategoryProgramDTO;
import aptech.finalproject.dto.exercise.ExerciseUserDTO;
import aptech.finalproject.dto.exercise.ExercisesDTO;
import aptech.finalproject.dto.exercise.FavoritesDTO;
import aptech.finalproject.dto.meal.UserSimpleDTO;
import aptech.finalproject.entity.exercise.EquipmentsModel;
import aptech.finalproject.entity.exercise.ExerciseCategoryModel;
import aptech.finalproject.entity.exercise.ExerciseFavoriteModel;
import aptech.finalproject.entity.exercise.ExerciseModeModel;
import aptech.finalproject.entity.exercise.ExerciseProgramsModel;
import aptech.finalproject.entity.exercise.ExerciseProgressModel;
import aptech.finalproject.entity.exercise.ExerciseScheduleModel;
import aptech.finalproject.entity.exercise.ExerciseSessionModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryProgramModel;
import aptech.finalproject.entity.exercise.ExerciseUserModel;
import aptech.finalproject.entity.exercise.ExercisesModel;
import aptech.finalproject.entity.exercise.FavoritesModel;

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

                Set<ExerciseModeDTO> modeDtos = entity.getModes()
                                .stream()
                                .map(mode -> new ExerciseModeDTO(mode.getId(), mode.getModeName()))
                                .collect(Collectors.toSet());
                dto.setModes(modeDtos);

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

                Set<ExerciseModeDTO> modeDtos = entity.getModes()
                                .stream()
                                .map(mode -> new ExerciseModeDTO(mode.getId(), mode.getModeName()))
                                .collect(Collectors.toSet());
                dto.setModes(modeDtos);

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
                                        entity.getUser().getFirstName(),
                                        entity.getUser().getLastName());
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
                        userDto = new UserSimpleDTO(entity.getUser().getId(), entity.getUser().getFirstName(),
                                        entity.getUser().getLastName());
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
                                        entity.getUser().getFirstName(),
                                        entity.getUser().getLastName());
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
                                        entity.getUser().getFirstName(),
                                        entity.getUser().getLastName());
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
                                        entity.getUser().getFirstName(),
                                        entity.getUser().getLastName());
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
                                        entity.getUser().getFirstName(),
                                        entity.getUser().getLastName());
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

        public static EquipmentsDTO toEquipmentsDto(EquipmentsModel entity) {
                if (entity == null) {
                        return null;
                }
                return new EquipmentsDTO(entity.getId(), entity.getEquipmentName(), entity.getEquipmentImage());
        }

        public static ExerciseModeDTO toModeDto(ExerciseModeModel entity) {
                if (entity == null) {
                        return null;
                }
                return new ExerciseModeDTO(entity.getId(), entity.getModeName());
        }
}
