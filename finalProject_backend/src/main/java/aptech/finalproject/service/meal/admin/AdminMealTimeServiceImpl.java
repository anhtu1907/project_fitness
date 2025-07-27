package aptech.finalproject.service.meal.admin;

import aptech.finalproject.dto.request.meal.MealTimeRequest;
import aptech.finalproject.dto.response.meal.MealTimeResponse;
import aptech.finalproject.entity.meal.MealTimeModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.meal.MealTimeMapper;
import aptech.finalproject.repository.meal.MealTimeRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminMealTimeServiceImpl implements AdminMealTimeService {

    private final MealTimeRepository mealTimeRepository;
    private final MealTimeMapper mealTimeMapper;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealTimeResponse create(MealTimeRequest request) {
        MealTimeModel entity = mealTimeMapper.toEntity(request);
        return mealTimeMapper.toResponse(mealTimeRepository.save(entity));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealTimeResponse update(Integer id, MealTimeRequest request) {
        MealTimeModel existing = mealTimeRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_TIME_NOT_FOUND));

        mealTimeMapper.update(existing, request);
        return mealTimeMapper.toResponse(mealTimeRepository.save(existing));
    }

    public MealTimeResponse getById(Integer id) {
        MealTimeModel time = mealTimeRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_TIME_NOT_FOUND));
        return mealTimeMapper.toResponse(time);
    }

    public List<MealTimeResponse> getAll() {
        return mealTimeRepository.findAll().stream()
                .map(mealTimeMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteById(Integer id) {
        if (!mealTimeRepository.existsById(id)) {
            throw new ApiException(ErrorCode.MEAL_TIME_NOT_FOUND);
        }
        mealTimeRepository.deleteById(id);
    }
}

