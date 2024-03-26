package com.orange.fintech.account.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.google.gson.JsonElement;
import com.orange.fintech.account.dto.ReqHeader;
import com.orange.fintech.account.dto.UpdateAccountDto;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.repository.AccountRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.member.service.MemberService;
import jakarta.transaction.Transactional;
import java.util.*;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

@Slf4j
@Service
@Transactional
public class AccountServiceImpl implements AccountService {
    @Autowired AccountRepository accountRepository;
    @Autowired MemberRepository memberRepository;

    @Autowired MemberService memberService;

    @Value("${ssafy.bank.search.accounts}")
    private String searchAccountsUrl;

    @Value("${ssafy.bank.search.main-account}")
    private String mainAccountsUrl;

    @Value("${ssafy.bank.transaction.history}")
    private String transactionHistoryUrl;

    @Value("${ssafy.bank.api-key}")
    private String apiKey;

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

    @Override
    public List<JSONObject> findAccountList(String memberId)
            throws JsonProcessingException, ParseException {
        String apinameAndApiServiceCode = getApinameAndApiServiceCode(searchAccountsUrl);

        Member member = memberRepository.findById(memberId).get();
        String userKey = member.getUserKey();

        ReqHeader reqHeader = createHeader(userKey, searchAccountsUrl);
        //        ReqHeader reqHeader = new ReqHeader();
        //        reqHeader.setApiKey(apiKey);
        //        reqHeader.setUserKey(userKey);
        //        reqHeader.setApiName(apinameAndApiServiceCode);
        //        reqHeader.setApiServiceCode(apinameAndApiServiceCode);

        RestClient.ResponseSpec response = null;
        RestClient restClient = RestClient.create();

        Map<String, Object> req = new HashMap<>();
        req.put("Header", reqHeader);

        response = restClient.post().uri(searchAccountsUrl).body(req).retrieve();
        String responseBody = response.body(String.class);

        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(responseBody);

        List<JSONObject> target = (List<JSONObject>) jsonObject.get("REC");
        //        log.info("responseBody : {}", responseBody);
        //
        // log.info("==========================================================================");
        //        log.info("obj : {}", jsonObject.get("REC"));
        //        log.info("target size: {}", target.size());
        //
        // log.info("==========================================================================");

        return target;
    }

    @Override
    public String getApinameAndApiServiceCode(String url) {
        String[] tmp = url.split("/");
        String result = tmp[tmp.length - 1];
        return result;
    }

    @Override
    public void updateMainAccount(String memberId, UpdateAccountDto dto) throws ParseException {
        Member member = memberRepository.findById(memberId).get();

        // 은행에서 이 계좌로 된거 불러와야함.
        ReqHeader reqHeader = createHeader(member.getUserKey(), mainAccountsUrl);

        RestClient.ResponseSpec response = null;
        RestClient restClient = RestClient.create();

        Map<String, Object> req = new HashMap<>();
        req.put("Header", reqHeader);
        req.put("bankCode", dto.getBankcode());
        req.put("accountNo", dto.getAcountNo());

        response = restClient.post().uri(mainAccountsUrl).body(req).retrieve();
        String responseBody = response.body(String.class);

        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(responseBody);
        JSONObject REC = (JSONObject) jsonObject.get("REC");

        Account account = new Account();
        account.setAccountNo(REC.get("accountNo").toString());
        account.setBankCode(REC.get("bankCode").toString());
        account.setBalance(Long.parseLong(REC.get("accountBalance").toString()));
        account.setMember(member);

        // 이전에 등록되어있던 주계좌는 주계좌가 아닌걸로~
        List<Account> prePrimaryAccount =
                accountRepository.findByMemberAndIsPrimaryAccountIsTrue(member);
        for (Account pre : prePrimaryAccount) {
            if (pre.getIsPrimaryAccount()) {

                pre.setIsPrimaryAccount(false);
                accountRepository.save(pre);
            }
        }

        Account saveData = accountRepository.save(account);

        // 거래내역 저장.
        String bankCode = saveData.getBankCode();
        String accountNo = saveData.getAccountNo();
        String startDate = "20240101";
        String endDate = "20241231";
        reqHeader = createHeader(member.getUserKey(), transactionHistoryUrl);
        getAllTransaction(bankCode, accountNo, startDate, endDate, reqHeader);
    }

    @Override
    public ReqHeader createHeader(String userKey, String reqUrl) {
        String apinameAndApiServiceCode = getApinameAndApiServiceCode(reqUrl);
        ReqHeader reqHeader = new ReqHeader();
        reqHeader.setApiKey(apiKey);
        reqHeader.setUserKey(userKey);
        reqHeader.setApiName(apinameAndApiServiceCode);
        reqHeader.setApiServiceCode(apinameAndApiServiceCode);

        return reqHeader;
    }

    @Override
    public void getAllTransaction(
            String bankCode,
            String accountNo,
            String startDate,
            String endDate,
            ReqHeader reqHeader)
            throws ParseException {
        Map<String, Object> req = new HashMap<>();
        req.put("Header", reqHeader);
        req.put("bankCode", bankCode);
        req.put("accountNo", accountNo);
        req.put("startDate", startDate);
        req.put("endDate", endDate);
        req.put("transactionType", "A");
        req.put("orderByType", "DESC");

        RestClient restClient = RestClient.create();
        RestClient.ResponseSpec response =
                restClient.post().uri(transactionHistoryUrl).body(req).retrieve();

        String responseBody = response.body(String.class);

        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(responseBody);
        JSONObject transactions = (JSONObject) jsonObject.get("REC");
        log.info("transactions :{}", transactions);
        JSONArray jsonArray = (JSONArray) transactions.get("list");
        log.info("jsonArray :{}", jsonArray);


        for (Object element : jsonArray){
            //transactionType : 1 -> 입금 | 2 -> 출금
            log.info("el:{}",element);// 여기서 입금 출금 각각 dto가 달라요. 차이: 출금에만 transactionAccountNo가 있다.

        }


    }
}
