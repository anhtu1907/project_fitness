package com.example.Project4.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Project4.dto.bmi.PersonHealDataRequest;
import com.example.Project4.services.bmi.BmiService;

@RestController
@RequestMapping("/api/bmi")
public class BMICaculatorController {
    @Autowired
    private BmiService bmiService;

    @PostMapping("/save/{userId}")
    public ResponseEntity<?> saveData(@RequestBody PersonHealDataRequest dto, @PathVariable int userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.saveData(dto, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }

    @PutMapping("/update/{userId}")
    public ResponseEntity<?> saveData(@RequestBody int weight, @PathVariable int userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.updateData(weight, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }

    @PostMapping("/goal/save/{userId}")
    public ResponseEntity<?> saveGoal(@RequestBody int targetWeight, @PathVariable int userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.saveGoal(targetWeight, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }

    @PutMapping("/goal/update/{userId}")
    public ResponseEntity<?> updateGoal(@RequestBody int targetWeight, @PathVariable int userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.updateGoal(targetWeight, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }
}
