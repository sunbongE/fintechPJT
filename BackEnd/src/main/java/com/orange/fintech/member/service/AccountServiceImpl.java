package com.orange.fintech.member.service;

import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AccountServiceImpl implements AccountService {
    @Autowired AccountRepository accountRepository;

    @Autowired MemberService memberService;

    @Override
    public boolean insertAccount(String kakaoId, Account account) {
        Member member = memberService.findByKakaoId(kakaoId);
        account.setMember(member);

        try {
            accountRepository.save(account);

            return true;
        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }
    }

    @Override
    public void updatePrimaryAccount(String kakaoId, String accountNo) {
        Member member = memberService.findByKakaoId(kakaoId);

        // 1. 기존 주 거래 계좌의 is_primary_account 값 false로 업데이트
        Account currentPrimaryAccount = accountRepository.findPrimaryAccountByKakaoId(member);
        currentPrimaryAccount.setIsPrimaryAccount(false);
        accountRepository.save(currentPrimaryAccount);

        // 2. 전달받은 계좌 번호의 is_primary_account 값 true로 업데이트
        Account newPrimaryAccount = accountRepository.findByAccountNo(accountNo);
        newPrimaryAccount.setIsPrimaryAccount(true);
        accountRepository.save(newPrimaryAccount);
    }
}
