package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.FavoritesRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.FavoritesResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminFavoritesService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/favorites")
@RequiredArgsConstructor
public class AdminFavoritesController {

    private final AdminFavoritesService service;

    @PostMapping("/create")
    public ApiResponse<FavoritesResponse> create(@RequestBody @Valid FavoritesRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        FavoritesResponse created = service.create(request);
        return ApiResponse.created(created, "Created favorite");
    }

    @PutMapping("/{id}")
    public ApiResponse<FavoritesResponse> update(@PathVariable int id,
                                                 @RequestBody @Valid FavoritesRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        FavoritesResponse updated = service.update(id, request);
        return ApiResponse.ok(updated, "Updated favorite");
    }

    @GetMapping
    public ApiResponse<List<FavoritesResponse>> getAll() {
        List<FavoritesResponse> list = service.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all favorites");
    }

    @GetMapping("/{id}")
    public ApiResponse<FavoritesResponse> getById(@PathVariable int id) {
        FavoritesResponse response = service.getById(id);
        return ApiResponse.ok(response, "Get favorite by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        service.delete(id);
        return ApiResponse.noContent("Deleted favorite with id " + id);
    }
}

