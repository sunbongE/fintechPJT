package com.orange.fintech.account.repository;

import com.orange.fintech.account.entity.Account;
import com.orange.fintech.member.entity.Member;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends JpaRepository<Account, String> {
    List<Account> findByMember(Member member);

    Account findByMemberAndIsPrimaryAccountIsTrue(Member member);

    Account findByAccountNo(String accountNo);

    @Query("SELECT a FROM Account a WHERE a.isPrimaryAccount IS TRUE AND a.member = :member")
    Account findPrimaryAccountByKakaoId(@Param("member") Member member);

    @Query("SELECT a FROM Account a WHERE a.accountNo = :accountNo AND a.member.kakaoId = :kakaoId")
    Account findAccountByAccountNoAndKakaoId(
            @Param("accountNo") String accountNo, @Param("kakaoId") String kakaoId);
}
