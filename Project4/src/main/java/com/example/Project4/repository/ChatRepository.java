package com.example.Project4.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.ChatModel;

@Repository
public interface ChatRepository extends JpaRepository<ChatModel, Integer>{
     @Query("SELECT c FROM ChatModel c WHERE (c.sender.id = :user1 AND c.receiver.id = :user2) OR (c.sender.id = :user2 AND c.receiver.id = :user1) ORDER BY c.sentAt ASC")
    List<ChatModel> findChatsBetweenUsers(@Param("user1") int user1, @Param("user2") int user2);

    @Query("SELECT c FROM ChatModel c WHERE c.sender.id = :senderId AND c.receiver.id = :receiverId AND c.status = 'sent'")
    List<ChatModel> findUnreadMessages(@Param("senderId") int senderId, @Param("receiverId") int receiverId);
}
