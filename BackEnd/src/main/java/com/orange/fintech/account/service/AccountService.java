package com.orange.fintech.account.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.orange.fintech.account.dto.ReqHeader;
import com.orange.fintech.account.dto.TransactionResDto;
import com.orange.fintech.account.dto.UpdateAccountDto;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.common.exception.AccountWithdrawalException;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.dto.ReceiptRequestDto;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
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

    ReqHeader createDummyTransactionHeader(
            String userKey, String reqUrl, LocalDate transactionDate, LocalTime transactionTime);

    void getAllTransaction(
            String bankCode,
            String accountNo,
            String startDate,
            String endDate,
            ReqHeader reqHeader,
            Member member,
            @NotNull LocalTime transactionTime)
            throws ParseException;

    List<TransactionResDto> readAllOrUpdateTransation(String memberId, int page, int pageSize)
            throws ParseException, AccountWithdrawalException;

    String inquireAccountBalance(Member member, Account primaryAccount) throws ParseException;

    void addSingleDummyTranactionRecord(String kakaoId, ReceiptRequestDto receiptRequestDto)
            throws ParseException, AccountWithdrawalException;

    void addDummyTranactionRecord(String kakaoId, List<ReceiptRequestDto> receiptRequestDtoList)
            throws ParseException;

    void transfer(String sendMemberId, String receiveMemberId, Long transactionBalance);

    boolean deposit(String userKey, String accountNo, Long balance);
}
