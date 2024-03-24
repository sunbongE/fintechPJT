package com.orange.fintech.member.repository;

import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.entity.ProfileImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProfileImageRepository extends JpaRepository<ProfileImage, String> {
    @Query("SELECT EXISTS(SELECT 1 FROM ProfileImage pi WHERE pi.member.kakaoId = :kakaoId)")
    boolean existsByKakaoId(@Param("kakaoId") String kakaoId);

    @Query("SELECT pi FROM ProfileImage pi WHERE pi.member.kakaoId = :kakaoId")
    ProfileImage findByKakaoId(@Param("kakaoId") String kakaoId);

    ProfileImage findByMember(Member member);
}
