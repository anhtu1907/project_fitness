package aptech.finalproject.controller.bmi;

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

import aptech.finalproject.dto.bmi.PersonalHealthDTO;
import aptech.finalproject.dto.bmi.PersonalHealthGoalDTO;
import aptech.finalproject.payload.bmi.PersonHealDataRequest;
import aptech.finalproject.payload.bmi.PersonTargetGoalRequest;
import aptech.finalproject.service.bmi.BmiService;

@RestController
@RequestMapping("/api/bmi")
public class BMICaculatorController {
     @Autowired
    private BmiService bmiService;

    @GetMapping("/health/{userId}")
    public ResponseEntity<?> getDataByUserId(@PathVariable String userId) {
        List<PersonalHealthDTO> healths = bmiService.getDataByUserId(userId);
        try {
            return ResponseEntity.status(200).body(healths);
        } catch (RuntimeException err) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(err);
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/goal/{userId}")
    public ResponseEntity<?> getGoalByUserId(@PathVariable String userId) {
         List<PersonalHealthGoalDTO> goals = bmiService.getGoalByUserId(userId);
        try {
            return ResponseEntity.status(200).body(goals);
        } catch (RuntimeException err) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(err);
        } catch (Exception err) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }
    

    @PostMapping("/save/{userId}")
    public ResponseEntity<?> saveData(@RequestBody PersonHealDataRequest dto, @PathVariable String userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.saveData(dto, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }

    @PostMapping("/update/{userId}")
    public ResponseEntity<?> updateData(@RequestBody PersonTargetGoalRequest req, @PathVariable String userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.updateData(req, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }

    @PostMapping("/goal/save/{userId}")
    public ResponseEntity<?> saveGoal(@RequestBody PersonTargetGoalRequest req, @PathVariable String userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.saveGoal(req, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }

    @PostMapping("/goal/update/{userId}")
    public ResponseEntity<?> updateGoal(@RequestBody PersonTargetGoalRequest req, @PathVariable String userId) {
        try {
            return ResponseEntity.status(201).body(bmiService.updateGoal(req, userId));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred.");
        }

    }
}
