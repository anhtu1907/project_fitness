package com.example.Project4.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.Project4.dto.ExerciseSessionRequest;
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
        try{
            return ResponseEntity.status(200).body(exerciseService.getExerciseById(exerciseId));
        }catch(RuntimeException e){
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
    public ResponseEntity<?> getAllExerciseProgressByUserId(@PathVariable int userId){
        try{
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseProgressByUserId(userId));
        }catch(Exception err){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/session/{userId}")
    public ResponseEntity<?> getAllExerciseSessionByUserId(@PathVariable int userId){
        try{
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseSessionByUserId(userId));
        }catch(Exception err){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getAllExerciseResultByUserId(@PathVariable int userId){
        try{
            return ResponseEntity.status(200).body(exerciseService.getAllExerciseResultByUserId(userId));
        }catch(Exception err){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

        @PostMapping("/start-session")
    public ResponseEntity<?> startExercise(@RequestBody ExerciseSessionRequest req) {
        return ResponseEntity.status(201).body(exerciseService.startExercise(req));
    }

}
