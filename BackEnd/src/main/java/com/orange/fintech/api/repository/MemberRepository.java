package com.orange.fintech.api.repository;

import com.orange.fintech.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends JpaRepository<Member, String > {
    boolean existsByEmail(String email);
}
