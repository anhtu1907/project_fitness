package aptech.finalproject.repository.bmi;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import aptech.finalproject.entity.bmi.PersonHealModel;

public interface PersonHealRepository extends JpaRepository<PersonHealModel, Integer> {
    PersonHealModel findTopByUserIdOrderByCreatedAtDesc(String userId);
    List<PersonHealModel> findAllHealthByUserId(String userId);
}
