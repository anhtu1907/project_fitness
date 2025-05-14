package com.example.Project4.repository.run;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.run.MetModel;

@Repository
public interface MetRepository extends JpaRepository<MetModel,Integer> {
    
}
