package com.orange.fintech.member.service;

import com.orange.fintech.member.entity.Account;

public interface AccountService {
    boolean insertAccount(String kakaoId, Account account);

    void updatePrimaryAccount(String kakaoId, String accountNo);
}
