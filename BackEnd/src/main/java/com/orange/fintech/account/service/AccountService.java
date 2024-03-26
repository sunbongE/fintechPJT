package com.orange.fintech.account.service;

import com.orange.fintech.account.entity.Account;

public interface AccountService {
    boolean insertAccount(String kakaoId, Account account);

    void updatePrimaryAccount(String kakaoId, String accountNo);
}
