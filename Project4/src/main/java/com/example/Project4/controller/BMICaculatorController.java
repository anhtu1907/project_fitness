package com.example.Project4.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
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

    @PostMapping("/save/{id}")
    public ResponseEntity<?> saveData(@RequestBody PersonHealDataRequest dto, @PathVariable("id") int userid) {
        try {
            return ResponseEntity.status(201).body(bmiService.saveData(dto, userid));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }
}
