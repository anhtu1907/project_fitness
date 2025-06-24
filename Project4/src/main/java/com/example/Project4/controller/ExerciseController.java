package com.example.Project4.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.Project4.models.exercise.ExerciseFavoriteModel;
import com.example.Project4.models.exercise.FavoritesModel;
import com.example.Project4.payload.exercise.ExerciseFavoriteRequest;
import com.example.Project4.payload.exercise.ExerciseScheduleRequest;
import com.example.Project4.payload.exercise.ExerciseSessionRequest;
import com.example.Project4.payload.exercise.ExerciseUpdateScheduleRequest;
import com.example.Project4.services.exercise.ExerciseService;

@Controller
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
    public ResponseEntity<?> getAllExerciseProgressByUserId(@PathVariable int userId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseProgressByUserId(userId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/session/{userId}")
    public ResponseEntity<?> getAllExerciseSessionByUserId(@PathVariable int userId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseSessionByUserId(userId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getAllExerciseResultByUserId(@PathVariable int userId) {
        try {
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseResultByUserId(userId));
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @PostMapping("/start-session")
    public ResponseEntity<?> startExercise(@RequestBody ExerciseSessionRequest req) {
        return ResponseEntity.status(201).body(exerciseService.startExercise(req));
    }

    // Schedule
    @GetMapping("/schedule/{userId}")
    public ResponseEntity<?> findSchedule(@PathVariable int userId) {
        return ResponseEntity.status(200).body(exerciseService.getAllScheduleByUserId(userId));
    }

    @GetMapping("/schedule/{scheduleId}/{userId}")
    public ResponseEntity<?> findSchedule(@PathVariable int scheduleId, @PathVariable int userId) {
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

    @DeleteMapping("/schedule/detele/time")
    public ResponseEntity<?> deleteScheduleByTime() {
        exerciseService.deleteAllExerciseScheduleByTime();
        return ResponseEntity.status(204).build();
    }

    // Favorite
    @GetMapping("/favorite/all/{userId}")
    public ResponseEntity<?> getAllFavoriteByUserId(@PathVariable int userId) {
        List<FavoritesModel> favorites = exerciseService.getAllFavoriteByUserId(userId);
        return ResponseEntity.status(200).body(favorites);
    }

    @GetMapping("/favorite/exercise/all/{userId}/{favoriteId}")
    public ResponseEntity<?> getAllExerciseFavoriteByUserId(@PathVariable int userId, @PathVariable int favoriteId) {
        List<ExerciseFavoriteModel> exercise = exerciseService.getAllExerciseFavoriteByUserId(userId,favoriteId);
        return ResponseEntity.status(200).body(exercise);
    }


    @PostMapping("/favorite/new/{userId}")
    public ResponseEntity<?> addNewFavoriteByUserId(@PathVariable int userId, @RequestBody String favoriteName) {
        try {
            FavoritesModel favorite = exerciseService.addNewFavoriteByUserId(userId, favoriteName);
            return ResponseEntity.status(201).body(favorite);   
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

    @PostMapping("/favorite/add/exercise/{userId}")
    public ResponseEntity<?> addNewFavoriteByUserId(@PathVariable int userId,
            @RequestBody ExerciseFavoriteRequest req) {
        try {
            ExerciseFavoriteModel favorite = exerciseService.addExerciseFavoriteByUserId(req, userId);
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

}
