package com.orange.fintech.account.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.orange.fintech.account.dto.AccountResDto;
import com.orange.fintech.account.entity.Account;
import java.util.List;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

public interface AccountService {
    boolean insertAccount(String kakaoId, Account account);

    void updatePrimaryAccount(String kakaoId, String accountNo);

    List<JSONObject> findAccountList(String memberId)
            throws JsonProcessingException, ParseException;

    String getApinameAndApiServiceCode(String url);
}
