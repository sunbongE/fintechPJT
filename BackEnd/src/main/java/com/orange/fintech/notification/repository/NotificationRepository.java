package com.orange.fintech.notification.repository;

import com.orange.fintech.member.entity.Member;
import com.orange.fintech.notification.entity.Notification;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {
    List<Notification> findAllByMember(Member member);
}
