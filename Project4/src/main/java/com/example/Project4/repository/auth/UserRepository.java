package com.example.Project4.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.auth.UserModel;

@Repository
public interface UserRepository extends JpaRepository<UserModel, Integer> {
    UserModel findByEmail(String email);

    @Query("Select u from UserModel u where u.pinCode = :code AND (:email is NULL or u.email =:email)")
    UserModel findByCode(
        @Param("pinCode") String code,
        @Param("email") String email);
}
