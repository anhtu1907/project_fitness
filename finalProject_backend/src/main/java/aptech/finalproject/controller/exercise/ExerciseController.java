package aptech.finalproject.controller.exercise;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import aptech.finalproject.dto.exercise.*;
import aptech.finalproject.payload.exercise.*;
import aptech.finalproject.service.exercise.ExerciseService;

@RestController
@RequestMapping("/api/exercise")
public class ExerciseController {
    @Autowired
    private ExerciseService exerciseService;

    @GetMapping("")
    public ResponseEntity<?> getAllExercise() {
        return ResponseEntity.status(200).body(exerciseService.getAllExercise());
    }

    @GetMapping("/{exerciseId}")
    public ResponseEntity<?> getExerciseById(@PathVariable int exerciseId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getExerciseById(exerciseId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/category")
    public ResponseEntity<?> getAllCategory() {
        return ResponseEntity.status(200).body(exerciseService.getAllCategory());
    }

    @GetMapping("/category/sub")
    public ResponseEntity<?> getAllSubCategory() {
        return ResponseEntity.status(200).body(exerciseService.getAllSubCategory());
    }

    @GetMapping("/category/sub/{subCategoryId}")
    public ResponseEntity<?> getExerciseBySubCategoryId(@PathVariable int subCategoryId) {
        return ResponseEntity.status(200).body(exerciseService.getExerciseBySubCategoryId(subCategoryId));
    }

    @GetMapping("/progress/{userId}")
    public ResponseEntity<?> getAllExerciseProgressByUserId(@PathVariable String userId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseProgressByUserId(userId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/session/{userId}")
    public ResponseEntity<?> getAllExerciseSessionByUserId(@PathVariable String userId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseSessionByUserId(userId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getAllExerciseResultByUserId(@PathVariable String userId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseResultByUserId(userId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }
    @GetMapping("/reset-batch")
    public ResponseEntity<?> getAllExerciseResultByUserId(@RequestParam String userId, @RequestParam int subCategoryId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getResetBatchBySubCategory(userId,subCategoryId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }


    @PostMapping("/start-session")
    public ResponseEntity<?> startExercise(@RequestBody ExerciseSessionBatchRequest req) {
        return ResponseEntity.status(201).body(exerciseService.startMultipleExercises(req));
    }

    // Schedule
    @GetMapping("/schedule/{userId}")
    public ResponseEntity<?> findSchedule(@PathVariable String userId) {
        return ResponseEntity.status(200).body(exerciseService.getAllScheduleByUserId(userId));
    }

    @GetMapping("/schedule/{scheduleId}/{userId}")
    public ResponseEntity<?> findSchedule(@PathVariable int scheduleId, @PathVariable String userId) {
        return ResponseEntity.status(200).body(exerciseService.findByIdAndUserId(scheduleId, userId));
    }

    @PostMapping("/schedule/save")
    public ResponseEntity<?> scheduleExercise(@RequestBody ExerciseScheduleRequest req) {
        return ResponseEntity.status(201).body(exerciseService.scheduleExercise(req));
    }

    @DeleteMapping("/schedule/{scheduleId}")
    public ResponseEntity<?> deleteExerciseSchdedule(@PathVariable int scheduleId) {
        exerciseService.deleteExerciseSchdedule(scheduleId);
        return ResponseEntity.status(204).build();
    }

    @PutMapping("/schedule/update")
    public ResponseEntity<?> updateScheduleExercise(@RequestBody ExerciseUpdateScheduleRequest req) {
        return ResponseEntity.status(201).body(exerciseService.updateScheduleExercise(req));
    }

    @DeleteMapping("/schedule/delete/time")
    public ResponseEntity<?> deleteScheduleByTime() {
        exerciseService.deleteAllExerciseScheduleByTime();
        return ResponseEntity.status(204).build();
    }

    // Favorite
    @GetMapping("/favorite/all/{userId}")
    public ResponseEntity<?> getAllFavoriteByUserId(@PathVariable String userId) {
        List<FavoritesDTO> favorites = exerciseService.getAllFavoriteByUserId(userId);
        return ResponseEntity.status(200).body(favorites);
    }

    @GetMapping("/favorite/exercise/all/{userId}/{favoriteId}")
    public ResponseEntity<?> getAllExerciseFavoriteByUserId(@PathVariable String userId, @PathVariable int favoriteId) {
        List<ExerciseFavoriteDTO> exercise = exerciseService.getAllExerciseFavoriteByUserId(userId,favoriteId);
        return ResponseEntity.status(200).body(exercise);
    }


    @PostMapping("/favorite/new/{userId}")
    public ResponseEntity<?> addNewFavoriteByUserId(@PathVariable String userId, @RequestBody String favoriteName) {
        try {
            FavoritesDTO favorite = exerciseService.addNewFavoriteByUserId(userId, favoriteName);
            return ResponseEntity.status(201).body(favorite);   
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

    @PostMapping("/favorite/add/exercise/{userId}")
    public ResponseEntity<?> addExerciseFavoriteByUserId(@PathVariable String userId,
            @RequestBody ExerciseFavoriteRequest req) {
        try {
            ExerciseFavoriteDTO favorite = exerciseService.addExerciseFavoriteByUserId(req, userId);
            return ResponseEntity.status(201).body(favorite);
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

    @DeleteMapping("/favorite/delete/{favoriteId}")
    public ResponseEntity<?> removeFavoriteByUserId(@PathVariable int favoriteId) {
        try {
            exerciseService.removeFavorite(favoriteId);
            return ResponseEntity.status(204).build();
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

    @DeleteMapping("/favorite/delete/exercise/{subCategoryId}")
    public ResponseEntity<?> removeExerciseFavoriteById(@PathVariable int subCategoryId) {
        try {
            exerciseService.removeExerciseFavorite(subCategoryId);
            return ResponseEntity.status(204).build();
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

    @GetMapping("/sub/category/program")
    public ResponseEntity<?> getAllSubCategoryProgram(){
        return ResponseEntity.status(200).body(exerciseService.getAllSubCategoryProgam());
    }
    // Exercise Mode
    @GetMapping("/mode/all")
    public ResponseEntity<?> getAllExerciseMode(){
        return ResponseEntity.status(200).body(exerciseService.getAllExerciseMode());
    }
    // Search
     @GetMapping("/search")
    public ResponseEntity<?> getAllSubCategoryByName(@RequestParam(required = false) String subCategoryName) {
        if (subCategoryName == null || subCategoryName.trim().isEmpty()) {
            return ResponseEntity.ok(exerciseService.getAllSubCategory());
        }
        return ResponseEntity.ok(exerciseService.searchBySubCategoryName(subCategoryName));
    }
    // Equipment
     @GetMapping("/equipment/{subCategoryId}")
    public ResponseEntity<?> getAllEquipmentBySubCategoryId(@PathVariable int subCategoryId) {
        try {
            List<EquipmentsDTO> equipments = exerciseService.getAllEquipmentBySubCategoryId(subCategoryId);
            return ResponseEntity.status(200).body(equipments);
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

     @GetMapping("/equipment/all")
    public ResponseEntity<?> getAllEquipment() {
        try {
            List<EquipmentsDTO> equipments = exerciseService.getAllEquipment();
            return ResponseEntity.status(200).body(equipments);
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }
    
}
