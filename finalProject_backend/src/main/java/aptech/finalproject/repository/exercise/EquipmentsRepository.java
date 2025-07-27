package aptech.finalproject.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import aptech.finalproject.entity.exercise.EquipmentsModel;

public interface EquipmentsRepository extends JpaRepository<EquipmentsModel, Integer> {
    @Query("SELECT e.equipment FROM ExercisesModel e WHERE e.id = :exerciseId")
    List<EquipmentsModel> getEquipmentByExerciseId(@Param("exerciseId") int exerciseId);

    @Query("""
                SELECT DISTINCT e.equipment
                FROM ExercisesModel e
                JOIN e.subCategory s
                WHERE s.id = :subCategoryId
            """)
    List<EquipmentsModel> getAllEquipmentBySubCategoryId(@Param("subCategoryId") int subCategoryId);

    @Query("SELECT DISTINCT e.equipment FROM ExercisesModel e WHERE e.equipment IS NOT NULL")
    List<EquipmentsModel> getAllExerciseEquipment();

    List<EquipmentsModel> findByEquipmentNameContainingIgnoreCase(String equipmentName);
}
