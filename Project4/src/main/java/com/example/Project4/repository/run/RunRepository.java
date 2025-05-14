package com.example.Project4.repository.run;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.run.RunModel;

@Repository
public interface RunRepository extends JpaRepository<RunModel,Integer> {
    List<RunModel> findAllRecordByUserId(int userId);
}
