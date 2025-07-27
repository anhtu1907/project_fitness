package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.Equipment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EquipmentRepository extends JpaRepository<Equipment, Long> {
    Page<Equipment> findAll(Pageable pageable);
}
