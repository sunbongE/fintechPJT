package com.orange.fintech.member.repository;

import com.orange.fintech.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends JpaRepository<Member, String> {
    boolean existsByKakaoId(String kakaoId);

    Member findByKakaoId(String kakaoId); // 회원 조회

    Member findByEmail(String email); // 회원 조회
}
