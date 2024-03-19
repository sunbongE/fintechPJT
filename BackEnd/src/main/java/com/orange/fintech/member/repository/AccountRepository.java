package com.orange.fintech.member.repository;

import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AccountRepository extends JpaRepository<Account, Integer> {
    List<Account> findByMember(Member member);
}
