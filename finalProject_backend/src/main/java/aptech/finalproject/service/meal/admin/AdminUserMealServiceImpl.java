package aptech.finalproject.service.meal.admin;

import aptech.finalproject.dto.request.meal.UserMealsRequest;
import aptech.finalproject.dto.response.meal.UserMealsResponse;
import aptech.finalproject.entity.auth.User;
import aptech.finalproject.entity.meal.MealsModel;
import aptech.finalproject.entity.meal.UserMealsModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.meal.UserMealsMapper;
import aptech.finalproject.repository.UserRepository;
import aptech.finalproject.repository.meal.MealsRepository;

import aptech.finalproject.repository.meal.UserMealsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminUserMealServiceImpl implements AdminUserMealService {

    private final UserMealsRepository userMealRepository;
    private final UserRepository userRepository;
    private final MealsRepository mealsRepository;
    private final UserMealsMapper userMealMapper;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public UserMealsResponse create(UserMealsRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));

        MealsModel meal = mealsRepository.findById(request.getMealId())
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_NOT_FOUND));

        UserMealsModel userMeal = userMealMapper.toEntity(request);
        userMeal.setUser(user);
        userMeal.setMeal(meal);

        return userMealMapper.toResponse(userMealRepository.save(userMeal));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public UserMealsResponse update(Integer id, UserMealsRequest request) {
        UserMealsModel existing = userMealRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.USER_MEAL_NOT_FOUND));

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));

        MealsModel meal = mealsRepository.findById(request.getMealId())
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_NOT_FOUND));

        userMealMapper.update(existing, request);
        existing.setUser(user);
        existing.setMeal(meal);

        return userMealMapper.toResponse(userMealRepository.save(existing));
    }

    public UserMealsResponse getById(Integer id) {
        UserMealsModel userMeal = userMealRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.USER_MEAL_NOT_FOUND));
        return userMealMapper.toResponse(userMeal);
    }

    public List<UserMealsResponse> getAll() {
        return userMealRepository.findAll().stream()
                .map(userMealMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteById(Integer id) {
        if (!userMealRepository.existsById(id)) {
            throw new ApiException(ErrorCode.USER_MEAL_NOT_FOUND);
        }
        userMealRepository.deleteById(id);
    }
}
