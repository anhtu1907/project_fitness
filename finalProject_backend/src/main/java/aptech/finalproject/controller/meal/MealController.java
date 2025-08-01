package aptech.finalproject.controller.meal;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import aptech.finalproject.payload.meal.UserMealsRequest;
import aptech.finalproject.service.meal.MealService;

@RestController
@RequestMapping("/api/meal")
public class MealController {
    @Autowired
    private MealService mealService;

    @GetMapping("")
    public ResponseEntity<?> getAllMeal() {
        return ResponseEntity.status(200).body(mealService.getAllMeal());
    }

    @GetMapping("/search")
    public ResponseEntity<?> getAllMealByName(@RequestParam(required = false) String mealName) {
        if (mealName == null || mealName.trim().isEmpty()) {
            return ResponseEntity.ok(mealService.getAllMeal());
        }
        return ResponseEntity.ok(mealService.searchByMealName(mealName));
    }

    @GetMapping("/{mealId}")
    public ResponseEntity<?> getMealById(@PathVariable int mealId) {
        return ResponseEntity.status(200).body(mealService.getMealById(mealId));
    }

    @GetMapping("/category")
    public ResponseEntity<?> getAllCategory() {
        return ResponseEntity.status(200).body(mealService.getAllCategory());
    }

    @GetMapping("/category/sub")
    public ResponseEntity<?> getAllSubCategory() {
        return ResponseEntity.status(200).body(mealService.getAllSubCategory());
    }

    @GetMapping("/category/sub/{subCategoryId}")
    public ResponseEntity<?> getMealBySubCategoryId(@PathVariable int subCategoryId) {
        return ResponseEntity.status(200).body(mealService.getMealBySubCategoryId(subCategoryId));
    }

    @PostMapping("/save/record")
    public ResponseEntity<?> saveRecordMeal(@RequestBody UserMealsRequest request) {
        return ResponseEntity.status(201).body(mealService.saveRecordMeal(request));
    }

    @GetMapping("/record/{userId}")
    public ResponseEntity<?> getRecordMeal(@PathVariable String userId) {
        return ResponseEntity.status(200).body(mealService.getRecordMeal(userId));
    }

    @DeleteMapping("/record/{recordId}")
    public ResponseEntity<?> deleteRecordMeal(@PathVariable int recordId) {
        mealService.deleteRecordMeal(recordId);
        return ResponseEntity.status(204).build();
    }

    @DeleteMapping("/record/{userId}/all/{targetDate}")
    public ResponseEntity<?> deleteAllRecordMeal(@PathVariable String userId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate targetDate) {
        mealService.deleteAllRecordMeal(userId, targetDate);
        return ResponseEntity.status(204).build();
    }
}
