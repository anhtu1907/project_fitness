package com.example.Project4.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Project4.dto.run.RunRequest;
import com.example.Project4.models.run.RunModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.run.MetRepository;
import com.example.Project4.repository.run.RunRepository;

@RestController
@RequestMapping("/api/run")
public class RunController {
    @Autowired
    private MetRepository metRepository;
    @Autowired
    private RunRepository runRepository;
    @Autowired
    private UserRepository userRepository;

    @PostMapping("/save/record")
    public ResponseEntity<?> saveRun(@RequestBody RunRequest request){
        return ResponseEntity.status(201).body(null);
    }

    @GetMapping("/record/{userId}")
    public ResponseEntity<?> getRecordRunByUserId(@PathVariable int userId){
        try{
            List<RunModel> runRecord = runRepository.findAllRecordByUserId(userId);
            return ResponseEntity.status(200).body(runRecord);
        }catch(Exception err){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }
}
