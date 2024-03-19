package com.orange.fintech.member.repository;

import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends JpaRepository<Account, Integer> {
    List<Account> findByMember(Member member);
}
