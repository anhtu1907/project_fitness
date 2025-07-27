package aptech.finalproject.repository.product;

import aptech.finalproject.entity.product.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findBySupplier(Supplier supplier);

    List<Product> findByEquipment(Equipment equipment);

    List<Product> findBySupplement(Supplement supplement);

    List<Product> findByNameLike(String name);
}
