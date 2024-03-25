package com.orange.fintech.account.service;

import com.orange.fintech.account.dto.AccountResDto;
import com.orange.fintech.account.entity.Account;
import java.util.List;

public interface AccountService {
    boolean insertAccount(String kakaoId, Account account);

    void updatePrimaryAccount(String kakaoId, String accountNo);

    List<AccountResDto> findAccountList(String memberId);

    String getApinameAndApiServiceCode(String url);
}
