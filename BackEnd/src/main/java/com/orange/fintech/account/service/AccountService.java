package com.orange.fintech.account.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.orange.fintech.account.dto.ReqHeader;
import com.orange.fintech.account.dto.TransactionResDto;
import com.orange.fintech.account.dto.UpdateAccountDto;
import com.orange.fintech.account.entity.Account;

import java.time.LocalTime;
import java.util.List;

import com.orange.fintech.member.entity.Member;
import jakarta.validation.constraints.NotNull;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

public interface AccountService {
    boolean insertAccount(String kakaoId, Account account);

    void updatePrimaryAccount(String kakaoId, String accountNo);

    List<JSONObject> findAccountList(String memberId)
            throws JsonProcessingException, ParseException;

    String getApinameAndApiServiceCode(String url);

    void updateMainAccount(String memberId, UpdateAccountDto dto) throws ParseException;

    ReqHeader createHeader(String userKey, String reqUrl);

    void getAllTransaction(
            String bankCode,
            String accountNo,
            String startDate,
            String endDate,
            ReqHeader reqHeader, Member member, @NotNull LocalTime transactionTime)
            throws ParseException;

    List<TransactionResDto> readAllOrUpdateTransation(String memberId) throws ParseException;
}
