package com.orange.fintech.member.repository;

import com.orange.fintech.member.entity.FcmToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FcmTokenRepository extends JpaRepository<FcmToken, Integer> {
    @Query("SELECT EXISTS(SELECT 1 FROM FcmToken ft WHERE ft.fcmToken = :fcmToken)")
    boolean existsByFcmToken(@Param("fcmToken") String fcmToken);

    @Modifying
    @Query("DELETE FROM FcmToken WHERE fcmToken = :fcmToken")
    int deleteByFcmToken(@Param("fcmToken") String fcmToken);
}
