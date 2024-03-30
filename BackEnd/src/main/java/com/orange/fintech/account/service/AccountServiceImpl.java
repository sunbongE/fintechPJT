package com.orange.fintech.account.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.orange.fintech.account.dto.LatestDateTimeDto;
import com.orange.fintech.account.dto.ReqHeader;
import com.orange.fintech.account.dto.TransactionResDto;
import com.orange.fintech.account.dto.UpdateAccountDto;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.repository.AccountQueryRepository;
import com.orange.fintech.account.repository.AccountRepository;
import com.orange.fintech.common.exception.AccountWithdrawalException;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.member.service.MemberService;
import com.orange.fintech.payment.dto.ReceiptRequestDto;
import com.orange.fintech.payment.entity.Transaction;
import com.orange.fintech.payment.entity.TransactionDetail;
import com.orange.fintech.payment.repository.TransactionDetailRepository;
import com.orange.fintech.payment.repository.TransactionRepository;
import com.orange.fintech.util.AccountDateTimeUtil;
import jakarta.transaction.Transactional;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.UnexpectedRollbackException;
import org.springframework.web.client.RestClient;

@Slf4j
@Service
@Transactional
public class AccountServiceImpl implements AccountService {
    @Autowired AccountRepository accountRepository;
    @Autowired MemberRepository memberRepository;

    @Autowired TransactionRepository transactionRepository;
    @Autowired TransactionDetailRepository transactionDetailRepository;
    @Autowired AccountQueryRepository accountQueryRepository;

    @Autowired MemberService memberService;

    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private String[] cardCompanyList = {"신한", "하나", "국민"};

    @Value("${ssafy.bank.search.accounts}")
    private String searchAccountsUrl;

    @Value("${ssafy.bank.search.main-account}")
    private String mainAccountsUrl;

    @Value("${ssafy.bank.transaction.history}")
    private String transactionHistoryUrl;

    @Value("${ssafy.bank.api-key}")
    private String apiKey;

    @Value("${ssafy.bank.inquire.account.balance}")
    private String inquireAccountBalanceUrl;

    @Value("${ssafy.bank.drawing.transfer}")
    private String drawingTransferUrl;

    @Value("${ssafy.bank.transfer}")
    private String transferUri;

    Random random = new Random();

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
        req.put("bankCode", dto.getBankCode());
        req.put("accountNo", dto.getAccountNo());

        response = restClient.post().uri(mainAccountsUrl).body(req).retrieve();
        String responseBody = response.body(String.class);

        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(responseBody);
        JSONObject REC = (JSONObject) jsonObject.get("REC");

        // 이전에 등록되어있던 주계좌는 주계좌가 아닌걸로~
        Account preAccount = accountRepository.findByMemberAndIsPrimaryAccountIsTrue(member);
        preAccount.setIsPrimaryAccount(false);
        accountRepository.save(preAccount);

        Account account = new Account();
        account.setAccountNo(REC.get("accountNo").toString());
        account.setBankCode(REC.get("bankCode").toString());
        account.setBalance(Long.parseLong(REC.get("accountBalance").toString()));
        account.setMember(member);

        Account saveData = accountRepository.save(account);

        // 거래내역 저장.
        String bankCode = saveData.getBankCode();
        String accountNo = saveData.getAccountNo();
        String startDate = "20240101";
        String endDate = "20241231";
        LocalTime transactionTime = null;
        LatestDateTimeDto latestData = accountQueryRepository.getLatest(memberId);

        // 최신 데이터가 있으면 있는 날짜부터 조회
        if (latestData != null) {
            startDate = AccountDateTimeUtil.localDateToString(latestData.getTransactionDate());
            transactionTime = latestData.getTransactionTime();
        }

        reqHeader = createHeader(member.getUserKey(), transactionHistoryUrl);
        getAllTransaction(
                bankCode, accountNo, startDate, endDate, reqHeader, member, transactionTime);
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
    public ReqHeader createDummyTransactionHeader(
            String userKey, String reqUrl, LocalDate transactionDate, LocalTime transactionTime) {
        ReqHeader reqHeader = createHeader(userKey, reqUrl);

        String transactionDateString = transactionDate.toString().replace("-", "");
        String transactionTimeString = transactionTime.toString().replace(":", "");

        // 225000인 경우 2250으로 처리됨 -> 보간
        if (transactionTimeString.length() == 4) {
            transactionDateString = transactionDateString + "00";
        }

        reqHeader.setTransmissionDate(transactionDateString);
        reqHeader.setTransmissionTime(transactionTimeString);

        return reqHeader;
    }

    /**
     * @param bankCode 은행코드
     * @param accountNo 계좌번호
     * @param startDate 조회 시작날짜
     * @param endDate 조회 끝날짜
     * @param reqHeader 요청 바디에 들어갈 헤더
     * @param member
     * @param transactionTime DB에 있는 가장 최신 데이터 시간.
     * @throws ParseException
     */
    @Override
    public void getAllTransaction(
            String bankCode,
            String accountNo,
            String startDate,
            String endDate,
            ReqHeader reqHeader,
            Member member,
            LocalTime transactionTime)
            throws ParseException {
        Map<String, Object> req = new HashMap<>();
        req.put("Header", reqHeader);
        req.put("bankCode", bankCode);
        req.put("accountNo", accountNo);
        req.put("startDate", startDate);
        req.put("endDate", endDate);
        req.put("transactionType", "A");
        req.put("orderByType", "DESC");
        log.info("startDate ====>>>> {}", startDate);
        // 처음 주계좌를 등록한것인지 확인하는 용도.
        boolean isInit = accountQueryRepository.transactionIsExists(accountNo);
        log.info("isInit : {} ", isInit);

        // 거래 내역이 이미 있는지 확인한다.

        // 지금 계좌로 연결된 거래내역이 없으면.

        LocalDate startDateValue = AccountDateTimeUtil.StringToLocalDate(startDate);

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

        Account curAccount = accountRepository.findByAccountNo(accountNo);

        List<Transaction> saveDataList = new ArrayList<>();

        // 여기서 처음인지 아닌지에 따라서 값을 비교해서 가져오든 전부 가져오든 할듯.
        for (Object element : jsonArray) {
            JSONObject tmp = (JSONObject) element;
            Transaction transaction = new Transaction(tmp, curAccount, member);

            if (isInit) {
                //            log.info("el:{}",element);// 여기서 입금 출금 각각 dto가 달라요. 차이: 출금에만
                // transactionAccountNo가 있다.
                if (tmp.get("transactionTypeName").equals("출금(이체)")
                        || tmp.get("transactionTypeName").equals("입금(이체)")) {
                    transaction.setTransactionAccountNo(tmp.get("transactionAccountNo").toString());
                }

                log.info("객체결과->> {}", transaction.toString());
                saveDataList.add(transaction);
            } else { // 새로고침인 경우.
                log.info(
                        "{} | {} | {} | {}",
                        transaction.getTransactionDate(),
                        startDateValue,
                        transaction.getTransactionTime(),
                        transactionTime);
                // 날짜가 같으면 시간을 비교해서 가져온다.
                if (transaction.getTransactionDate().isEqual(startDateValue)
                        && transaction.getTransactionTime().isAfter(transactionTime)) {
                    saveDataList.add(transaction);
                    log.info("여긴가?!");
                } else if (transaction.getTransactionDate().isAfter(startDateValue)) {
                    saveDataList.add(transaction);
                }
            }
            // Todo : 거래내역 최신화 후 다시 주석 해제

        }

        log.info("저장할 데이터 => {}", saveDataList);
        // 저장할 데이터가 있으면 저장.
        if (!saveDataList.isEmpty()) {
            List<Transaction> savedAll = transactionRepository.saveAll(saveDataList);

            // 디테일 생성.
            List<TransactionDetail> transactionDetailList = new ArrayList<>();
            for (Transaction data : savedAll) {
                TransactionDetail detail = new TransactionDetail();
                detail.setTransactionId(data.getTransactionId());
                transactionDetailList.add(detail);
            }
            transactionDetailRepository.saveAll(transactionDetailList);
        }
    }

    @Override
    public List<TransactionResDto> readAllOrUpdateTransation(String memberId)
            throws ParseException {
        log.info("impl call");

        // DB에서 가장 최근의 데이터의 날짜와 시간을 가져온다.
        LatestDateTimeDto latestData = accountQueryRepository.getLatest(memberId);
        //        log.info("latestData:{}",latestData); //
        // LatestDateTimeDto(transactionDate=2024-03-27, transactionTime=11:14:59)
        Member member = memberRepository.findById(memberId).get();
        //        List<Account> accountList =
        // accountRepository.findByMemberAndIsPrimaryAccountIsTrue(member);
        Account account = accountRepository.findByMemberAndIsPrimaryAccountIsTrue(member); // 주계좌

        // 최근값 이후로 데이터 받아서 저장하기.
        RestClient restClient = RestClient.create();
        RestClient.ResponseSpec bankResponse = null;

        String bankCode = account.getBankCode();
        String accountNo = account.getAccountNo();
        String startDate = AccountDateTimeUtil.localDateToString(latestData.getTransactionDate());
        String endDate = "20241231";
        ReqHeader reqHeader = createHeader(member.getUserKey(), transactionHistoryUrl);

        //        log.info("reqHeader:{}, date,time :{}, {}",reqHeader,startDate,endDate);
        getAllTransaction(
                bankCode,
                accountNo,
                startDate,
                endDate,
                reqHeader,
                member,
                latestData.getTransactionTime());

        // ========= DB에 저장된 데이터를 반환
        List<TransactionResDto> response = new ArrayList<>();

        // 회원아이디로 주계좌 회원, 계좌 조인해서 회원의 주계좌 가져온다.
        List<Transaction> transactions = accountQueryRepository.readAllOrUpdateTransation(memberId);
        //        log.info("transactions:{}",transactions);
        for (Transaction transaction : transactions) {
            TransactionResDto data = new TransactionResDto(transaction);
            response.add(data);
        }

        return response;
    }

    @Override
    public String inquireAccountBalance(Member member, Account primaryAccount)
            throws ParseException {
        // 1-1. SSAFY Bank API 호출을 위한 Body 객체 생성
        Map<String, Object> requestBody = new HashMap<>();

        // 1-2. 'Body에 넣을' Header value 객체 생성 및 추가
        ReqHeader reqHeader = createHeader(member.getUserKey(), inquireAccountBalanceUrl);
        requestBody.put("Header", reqHeader);

        // 1-3. Body에 "Header"를 제외한 다른 key-value 쌍 추가
        requestBody.put("bankCode", primaryAccount.getBankCode());
        requestBody.put("accountNo", primaryAccount.getAccountNo());

        // 2-1. SSAFY Bank API 호출
        RestClient restClient = RestClient.create();
        RestClient.ResponseSpec response =
                restClient.post().uri(inquireAccountBalanceUrl).body(requestBody).retrieve();

        // 2-2. 응답 코드 해석
        ResponseEntity<?> responseEntity = response.toEntity(String.class);
        String responseBody = responseEntity.getBody().toString();

        return responseBody;
    }

    @Override
    public void addSingleDummyTranactionRecord(String kakaoId, ReceiptRequestDto receiptRequestDto)
            throws ParseException, AccountWithdrawalException {
        Member member = memberService.findByKakaoId(kakaoId);

        try {
            // 1. 거래일시 파싱 (예: 2024-01-23 22:51:01 -> 2024-01-23 / 22:51:01)
            // 1-1. 문자열을 LocalDate 객체로 파싱
            LocalDate transactionDate =
                    LocalDate.parse(receiptRequestDto.getDate(), dateTimeFormatter);

            // 1-2. 문자열을 LocalTime 객체로 파싱
            LocalTime transactionTime =
                    LocalTime.parse(receiptRequestDto.getDate(), dateTimeFormatter);

            Transaction transaction =
                    transactionRepository.findReceiptApostropheForeignkey(
                            transactionDate, transactionTime, kakaoId);

            // 2. 업로드한 영수증에 해당하는 결제 정보 (Record)를 Transaction 테이블에서 찾을 수 없는 경우 추가
            if (transaction == null) {
                log.info("transaction == null 진입");
                // 2-1-1. SSAFY Bank API 호출을 위한 Body 객체 생성
                Map<String, Object> requestBody = new HashMap<>();

                // 2-1-2. 'Body에 넣을' Header value 객체 생성 및 추가
                ReqHeader reqHeader =
                        createDummyTransactionHeader(
                                member.getUserKey(),
                                drawingTransferUrl,
                                transactionDate,
                                transactionTime);
                requestBody.put("Header", reqHeader);

                // 2-1-3. Body에 "Header"를 제외한 다른 key-value 쌍 추가
                Account primaryAccount = accountRepository.findPrimaryAccountByKakaoId(member);
                random.setSeed(System.currentTimeMillis());
                String transactionSummary = cardCompanyList[random.nextInt(3)] + "체크승인";

                requestBody.put("bankCode", primaryAccount.getBankCode());
                requestBody.put("accountNo", primaryAccount.getAccountNo());
                requestBody.put("transactionBalance", receiptRequestDto.getApprovalAmount());
                requestBody.put(
                        "transactionSummary",
                        transactionSummary); // "신한", "하나", "국민" 중 1개 카드사 + "체크승인" (예: 신한체크승인)

                // 2-1-4. SSAFY Bank API 호출
                // TODO: 삭제
                HttpStatusCode statusCode = null;
                String responseBody = null;
                try {
                    RestClient restClient = RestClient.create();
                    RestClient.ResponseSpec response =
                            restClient.post().uri(drawingTransferUrl).body(requestBody).retrieve();

                    ResponseEntity<?> responseEntity = response.toEntity(String.class);
                    responseBody = responseEntity.getBody().toString();
                    statusCode = responseEntity.getStatusCode();

                    // 2-1-5. drawingTransferParser 추출
                    JSONParser drawingTransferParser = new JSONParser();
                    JSONObject drawingTransferJsonObject =
                            (JSONObject) drawingTransferParser.parse(responseBody);
                    JSONObject drawingTransferRec =
                            (JSONObject) drawingTransferJsonObject.get("REC");
                    String drawingTransferTransactionUniqueNo =
                            (String) drawingTransferRec.get("transactionUniqueNo");
                } catch (Exception e) {
                    throw e;
                }

                // 2-2. 출금 성공
                if (statusCode.is2xxSuccessful()) {
                    JSONParser parser = new JSONParser();
                    JSONObject jsonObject = (JSONObject) parser.parse(responseBody);
                    JSONObject responseHeader = (JSONObject) jsonObject.get("Header");

                    // 2-2-1. 잔액 조회 응답 Body 해석
                    String inquireAccountBalanceResponseBody =
                            inquireAccountBalance(member, primaryAccount);

                    JSONParser inquireAccountBalanceParser = new JSONParser();
                    JSONObject inquireAccountJsonObject =
                            (JSONObject)
                                    inquireAccountBalanceParser.parse(
                                            inquireAccountBalanceResponseBody);
                    JSONObject inquireAccountResponseHeader =
                            (JSONObject) inquireAccountJsonObject.get("Header");
                    String inquireAccountResponseCode =
                            (String) inquireAccountResponseHeader.get("responseCode");

                    JSONObject REC = (JSONObject) inquireAccountJsonObject.get("REC");

                    // Transaction 테이블에 결제 정보 레코드 추가
                    /*
                    transaction = new Transaction();

                    try {
                        transaction.setMember(member);
                        transaction.setAccount(primaryAccount);
                        transaction.setTransactionUniqueNo(
                                Integer.parseInt(drawingTransferTransactionUniqueNo));
                        // transaction.setTransactionAccountNo();    //Null
                        transaction.setTransactionDate(transactionDate);
                        transaction.setTransactionTime(transactionTime);
                        transaction.setTransactionType(String.valueOf(2)); // 1: 입금, 2: 출금
                        transaction.setTransactionTypeName("출금");
                        transaction.setTransactionBalance(
                                Long.valueOf(receiptRequestDto.getApprovalAmount()));
                        transaction.setTransactionAfterBalance(
                                Long.parseLong(REC.get("accountBalance").toString()));
                        transaction.setTransactionSummary(transactionSummary);
                        // transaction.setTransactionDetail();   //Null

                        transactionRepository.save(transaction);

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    */
                } else {
                    throw new AccountWithdrawalException();
                }
            }

            // 3. 업로드한 영수증에 해당하는 결제 정보 (Record)를 Transaction 테이블에서 찾은 경우 -> 스킵
        } catch (DataIntegrityViolationException | UnexpectedRollbackException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void addDummyTranactionRecord(
            String kakaoId, List<ReceiptRequestDto> receiptRequestDtoList) throws ParseException {
        for (ReceiptRequestDto receiptRequestDto : receiptRequestDtoList) {
            try {
                addSingleDummyTranactionRecord(kakaoId, receiptRequestDto);
            } catch (DataIntegrityViolationException
                    | UnexpectedRollbackException e) { // 중복 레코드 발생 -> 저장 스킵
            } catch (Exception e) {
            }
        }
    }

    @Override
    public void transfer(String sendMemberId, String receiveMemberId, Long transactionBalance) {
        boolean flag = true;
        do {

            RestClient restClient = RestClient.create();

            Member sendMember = memberRepository.findById(sendMemberId).get();
            Account sendMemberAccount =
                    accountRepository.findByMemberAndIsPrimaryAccountIsTrue(sendMember);

            Member receiveMember = memberRepository.findById(receiveMemberId).get();
            Account receiveMemberAccount =
                    accountRepository.findByMemberAndIsPrimaryAccountIsTrue(receiveMember);

            ReqHeader reqHeader = createHeader(sendMember.getUserKey(), transferUri);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("Header", reqHeader);
            requestBody.put("depositBankCode", receiveMemberAccount.getBankCode());
            requestBody.put("depositAccountNo", receiveMemberAccount.getAccountNo());
            requestBody.put("depositTransactionSummary", sendMember.getName());
            requestBody.put("transactionBalance", transactionBalance);
            requestBody.put("withdrawalBankCode", sendMemberAccount.getBankCode());
            requestBody.put("withdrawalAccountNo", sendMemberAccount.getAccountNo());
            requestBody.put("withdrawalTransactionSummary", receiveMember.getName());

            RestClient.ResponseSpec response =
                    restClient.post().uri(transferUri).body(requestBody).retrieve();
            ResponseEntity<?> responseEntity = response.toEntity(String.class);
            String responseBody = responseEntity.getBody().toString();
            HttpStatusCode statusCode = responseEntity.getStatusCode();

            // 이체 성공시 종료
            if (statusCode.is2xxSuccessful()) {
                flag = false;
            }

        } while (flag);
    }
}
