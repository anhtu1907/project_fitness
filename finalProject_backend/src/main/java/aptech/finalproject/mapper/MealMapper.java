package aptech.finalproject.mapper;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import aptech.finalproject.dto.meal.MealCategoryDTO;
import aptech.finalproject.dto.meal.MealSubCategoryDTO;
import aptech.finalproject.dto.meal.MealTimeDTO;
import aptech.finalproject.dto.meal.MealsDTO;
import aptech.finalproject.dto.meal.UserMealDTO;
import aptech.finalproject.dto.meal.UserSimpleDTO;
import aptech.finalproject.entity.meal.MealCategoryModel;
import aptech.finalproject.entity.meal.MealSubCategoryModel;
import aptech.finalproject.entity.meal.MealsModel;
import aptech.finalproject.entity.meal.UserMealsModel;

public class MealMapper {
    public static MealSubCategoryDTO toSubCategoryDto(MealSubCategoryModel entity) {
        MealSubCategoryDTO dto = new MealSubCategoryDTO();
        dto.setId(entity.getId());
        dto.setSubCategoryName(entity.getSubCategoryName());
        dto.setSubCategoryImage(entity.getSubCategoryImage());
        dto.setDescription(entity.getDescription());

        if (entity.getCategory() != null) {
            MealCategoryDTO categoryDto = new MealCategoryDTO();
            categoryDto.setId(entity.getCategory().getId());
            categoryDto.setCategoryImage(entity.getCategory().getCategoryImage());
            categoryDto.setCategoryName(entity.getCategory().getCategoryName());
            dto.setCategory(categoryDto);
        } else {
            dto.setCategory(null);
        }

        return dto;
    }

    public static MealCategoryDTO toCategoryDto(MealCategoryModel entity) {
        if (entity == null)
            return null;

        List<MealSubCategoryDTO> subDtos = entity.getSubCategory()
                .stream()
                .map(MealMapper::toSubCategoryDto)
                .collect(Collectors.toList());

        return new MealCategoryDTO(
                entity.getId(),
                entity.getCategoryImage(),
                entity.getCategoryName(),
                subDtos);
    }

    public static MealsDTO toMealDto(MealsModel entity) {
        if (entity == null)
            return null;

        Set<MealSubCategoryDTO> subDtos = entity.getSubCategory()
                .stream()
                .map(MealMapper::toSubCategoryDto)
                .collect(Collectors.toSet());

        Set<MealTimeDTO> timeDtos = entity.getTimeOfDay()
                .stream()
                .map(time -> new MealTimeDTO(time.getId(), time.getTimeName()))
                .collect(Collectors.toSet());

        return new MealsDTO(
                entity.getId(),
                entity.getMealName(),
                entity.getMealImage(),
                entity.getWeight(),
                entity.getKcal(),
                entity.getProtein(),
                entity.getFat(),
                entity.getCarbonhydrate(),
                entity.getFiber(),
                entity.getSugar(),
                subDtos,
                timeDtos);
    }

    public static UserMealDTO toUserMealDTO(UserMealsModel entity) {
        if (entity == null)
            return null;
        UserSimpleDTO userDto = null;
        if (entity.getUser() != null) {
            userDto = new UserSimpleDTO(
                    entity.getUser().getId(),
                    entity.getUser().getFirstName(),
                    entity.getUser().getLastName());
        }

        MealsDTO mealDto = null;
    if (entity.getMeal() != null) {
        mealDto = MealMapper.toMealDto(entity.getMeal());
    }
        return new UserMealDTO(
                entity.getId(),
                userDto,
                mealDto,
                entity.getCreatedAt());
    }
}
