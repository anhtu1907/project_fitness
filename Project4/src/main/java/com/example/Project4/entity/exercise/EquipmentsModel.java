package com.example.Project4.entity.exercise;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="exercise_equipment")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EquipmentsModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "equipment_name")
    private String equipmentName;
    @Column(name = "equipment_image")
    private String equipmentImage;
}
