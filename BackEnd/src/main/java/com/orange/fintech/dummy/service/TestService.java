package com.orange.fintech.dummy.service;

import com.orange.fintech.account.dto.ReqHeader;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.repository.AccountQueryRepository;
import com.orange.fintech.account.repository.AccountRepository;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.dummy.dto.UserKeyAccountPair;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.ReceiptDetail;
import com.orange.fintech.payment.entity.Transaction;
import com.orange.fintech.payment.repository.ReceiptDetailRepository;
import com.orange.fintech.payment.repository.ReceiptRepository;
import com.orange.fintech.payment.repository.TransactionRepository;
import com.orange.fintech.util.AccountDateTimeUtil;
import jakarta.transaction.Transactional;
import java.io.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

@Slf4j
@Service
@Transactional
public class TestService {
    @Autowired AccountService accountService;

    @Autowired MemberRepository memberRepository;

    @Autowired TransactionRepository transactionRepository;

    @Autowired AccountQueryRepository accountQueryRepository;

    @Autowired AccountRepository accountRepository;

    @Autowired ReceiptRepository receiptRepository;

    @Autowired ReceiptDetailRepository receiptDetailRepository;

    @Value("${ssafy.bank.drawing.transfer}")
    private String drawingTransferUrl;

    @Value("${ssafy.bank.transaction.history}")
    private String transactionHistoryUrl;

    private List<Map<String, Object>> dummyRecords = new ArrayList<>();

    int groupMemberCount = 7;
    String bankCode = "001";
    String startDate = "20240101";
    String endDate = "20241231";
    LocalDate startDateValue = AccountDateTimeUtil.StringToLocalDate(startDate);

    private void loadData(String filename) throws FileNotFoundException {
        String filePath = "resources/" + filename + ".csv";
        String line;

        // File이 없으면 예외 발생
        File file = new File(filePath);
        if (!file.exists()) {
            throw new FileNotFoundException();
        }

        // File이 있으면 List 초기화 후 다시 넣음
        dummyRecords.clear();

        try (BufferedReader br =
                new BufferedReader(new InputStreamReader(new FileInputStream(filePath)))) {
            // 한 줄 (제목 행) 버리기
            Map<String, Object> map = new HashMap<>();
            Map<String, Object> menuMap = new HashMap<>();
            List<Map<String, Object>> menuList = new ArrayList<>();
            line = br.readLine();

            while ((line = br.readLine()) != null) {
                String[] tokens = line.split(",");

                if (tokens.length == 0) {
                    dummyRecords.add(map);
                    map.put("menuList", menuList);

                    map = new HashMap<>();
                    menuList = new ArrayList<>();
                } else if (tokens.length == 9) {
                    // 7: 주소, 8: 금액
                    map.put("payer", tokens[1]);
                    map.put("storeName", tokens[2]);
                    map.put("location", tokens[7]);
                    map.put("approvalAmount", tokens[8]);
                } else if (tokens.length == 7) {
                    // 3: 메뉴, 4: 단가, 5: 수량, 6: 소계
                    menuMap = new HashMap<>();

                    menuMap.put("menu", tokens[3]);
                    menuMap.put("unitPrice", tokens[4]);
                    menuMap.put("count", tokens[5]);
                    menuMap.put("subTotal", tokens[6]);

                    menuList.add(menuMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String randomGenerator() {
        StringBuilder sb = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < 20; i++) {
            sb.append(random.nextInt(10));
        }

        return sb.toString();
    }

    // 그룹원의 거래 내역 갱신 (SSAFY Bank API를 호출하여 서비스 서버의 Transaction 테이블 갱신)
    public void refreshTransactionUsingSSAFYAPI(List<UserKeyAccountPair> userKeyAccountPairList)
            throws Exception {
        ReqHeader[][] reqHeaderList = new ReqHeader[2][groupMemberCount];
        UserKeyAccountPair userKeyAccountPair = null;

        for (int i = 0; i < groupMemberCount; i++) {
            userKeyAccountPair = userKeyAccountPairList.get(i);
            LocalTime transactionTime = null;

            // 0: 거래내역 조회, 1: 출금
            reqHeaderList[0][i] =
                    accountService.createHeader(
                            userKeyAccountPair.getUserKey(), transactionHistoryUrl);
            reqHeaderList[1][i] =
                    accountService.createHeader(
                            userKeyAccountPair.getUserKey(), drawingTransferUrl);

            // 이전에 등록되어있던 주 계좌 해제
            Member member = memberRepository.findByKakaoId(userKeyAccountPair.getKakaoId());
            Account preAccount = accountRepository.findByMemberAndIsPrimaryAccountIsTrue(member);

            if (preAccount != null) {
                preAccount.setIsPrimaryAccount(false);
                accountRepository.save(preAccount);
            }

            // 새로운 계좌 등록
            Account account = new Account();
            account.setAccountNo(userKeyAccountPair.getAccountNo());
            account.setMember(member);
            account.setBalance(5_000_000L);
            account.setIsPrimaryAccount(true);

            Map<String, Object> req = new HashMap<>();
            req.put("Header", reqHeaderList[0][i]);
            req.put("bankCode", bankCode);
            req.put("accountNo", userKeyAccountPair.getAccountNo());
            req.put("startDate", startDate);
            req.put("endDate", endDate);
            req.put("transactionType", "A");
            req.put("orderByType", "DESC");

            RestClient restClient = RestClient.create();
            RestClient.ResponseSpec response =
                    restClient.post().uri(transactionHistoryUrl).body(req).retrieve();
            Thread.sleep(1000);
            String responseBody = response.body(String.class);

            JSONParser parser = new JSONParser();
            JSONObject jsonObject = (JSONObject) parser.parse(responseBody);
            JSONObject REC = (JSONObject) jsonObject.get("REC");
            JSONArray jsonArray = (JSONArray) REC.get("list");

            // 처음 주계좌를 등록한것인지 확인하는 용도.
            boolean isInit =
                    accountQueryRepository.transactionIsExists(userKeyAccountPair.getAccountNo());

            List<Transaction> saveDataList = new ArrayList<>();

            if (jsonArray != null) {
                for (Object element : jsonArray) {
                    JSONObject tmp = (JSONObject) element;
                    Transaction transaction = new Transaction(tmp, account, member);

                    if (isInit) {
                        if (tmp.get("transactionTypeName").equals("출금(이체)")
                                || tmp.get("transactionTypeName").equals("입금(이체)")) {
                            transaction.setTransactionAccountNo(
                                    tmp.get("transactionAccountNo").toString());
                        }

                        saveDataList.add(transaction);
                    } else { // 새로고침인 경우.
                        // 날짜가 같으면 시간을 비교해서 가져온다..
                        if (transaction.getTransactionDate().isEqual(startDateValue)
                                && transaction.getTransactionTime().isAfter(transactionTime)) {
                            saveDataList.add(transaction);
                        } else if (transaction.getTransactionDate().isAfter(startDateValue)) {
                            saveDataList.add(transaction);
                        }
                    }
                }
            }
        }
    }

    public void postDummyTranaction(List<UserKeyAccountPair> userKeyAccountPairList)
            throws Exception {
        ReqHeader[][] reqHeaderList = new ReqHeader[2][groupMemberCount];
        UserKeyAccountPair userKeyAccountPair = null;

        if (userKeyAccountPairList.size() != groupMemberCount) {

            throw new Exception();
        }

        // 1. 그룹원의 거래 내역 갱신 (SSAFY Bank API를 호출하여 서비스 서버의 Transaction 테이블 갱신)
        refreshTransactionUsingSSAFYAPI(userKeyAccountPairList);

        // 2. 잔액 충전
        for (int i = 0; i < groupMemberCount; i++) {
            userKeyAccountPair = userKeyAccountPairList.get(i);

            // 잔액 충전 (오백만원)
            accountService.deposit(
                    userKeyAccountPair.getUserKey(), userKeyAccountPair.getAccountNo(), 5_000_000L);
        }

        // 3. 더미 레코드가 저장된 CSV 파일 로드
        loadData("dummyRecords");

        // 4. SSAFY Bank API를 호출
        for (int i = 0; i < dummyRecords.size(); i++) {
            Map<String, Object> dummyRecord = dummyRecords.get(i);

            // userKeyAccountPair 재 대입
            int payerIndex = Integer.parseInt(dummyRecord.get("payer").toString()) - 1;
            userKeyAccountPair = userKeyAccountPairList.get(payerIndex);
            Long balance = Long.valueOf(dummyRecord.get("approvalAmount").toString());
            String transactionSummary = dummyRecord.get("storeName").toString();

            if (!transactionRepository.doesDummyRecordAlreadyExists(
                    userKeyAccountPair.getKakaoId(), transactionSummary, balance)) {
                HttpStatusCode statusCode = null;
                long start, now;

                do {
                    reqHeaderList[1][payerIndex].setInstitutionTransactionUniqueNo(
                            randomGenerator()); // 기관고유번호 교체
                    start = System.currentTimeMillis();
                    // 거래 내역이 없으면 SSAFY Bank API를 호출
                    // 4-1. SSAFY Bank API 호출을 위한 Body 객체 생성
                    Map<String, Object> requestBody = new HashMap<>();

                    // 4-2. 'Body에 넣을' Header value 객체 생성 및 추가
                    requestBody.put("Header", reqHeaderList[1][payerIndex]);

                    // 4-3. Body에 "Header"를 제외한 다른 key-value 쌍 추가
                    requestBody.put("bankCode", "001");
                    requestBody.put("accountNo", userKeyAccountPair.getAccountNo());
                    requestBody.put("transactionBalance", balance);
                    requestBody.put("transactionSummary", transactionSummary);

                    // 4-4. SSAFY Bank API 호출
                    RestClient restClient = RestClient.create();
                    RestClient.ResponseSpec response =
                            restClient.post().uri(drawingTransferUrl).body(requestBody).retrieve();
                    Thread.sleep(1000);

                    // 4-5. 응답 코드 해석
                    ResponseEntity<?> responseEntity = response.toEntity(String.class);
                    String responseBody = responseEntity.getBody().toString();
                    statusCode = responseEntity.getStatusCode();
                    JSONParser parser = new JSONParser();
                    JSONObject jsonObject = (JSONObject) parser.parse(responseBody);
                    JSONObject responseHeader = (JSONObject) jsonObject.get("Header");

                    now = System.currentTimeMillis();
                } while ((now - start) / 1000 <= 1.5 && !statusCode.is2xxSuccessful());
            }
        }

        // 5. 그룹원의 거래 내역 갱신 (SSAFY Bank API를 호출하여 서비스 서버의 Transaction 테이블 갱신)
        refreshTransactionUsingSSAFYAPI(userKeyAccountPairList);

        // 6. receipt와 receipt_detail 테이블에 레코드 추가
        while (!dummyRecords.isEmpty()) {
            for (Map<String, Object> record : dummyRecords) {
                // 테이블에 레코드 추가 후 삭제
                String storeName = (String) record.get("storeName");
                String location = (String) record.get("location");
                int payer = Integer.parseInt((String) record.get("payer")) - 1; // 1부터 시작이므로 -1
                Long transactionBalance = Long.parseLong((String) record.get("approvalAmount"));
                LocalDate transactionDate = LocalDate.now();

                // 일치하는 레코드 발견
                Transaction transaction =
                        transactionRepository.findDummyTargetReceipt(
                                transactionBalance, transactionDate);

                if (transaction != null) {
                    Receipt receipt = new Receipt();

                    receipt.setTransaction(transaction);
                    receipt.setBusinessName(storeName);
                    // receipt.setSubName();   //null
                    receipt.setLocation(location);
                    receipt.setTransactionDate(transaction.getTransactionDate());
                    receipt.setTransactionTime(transaction.getTransactionTime());
                    receipt.setTotalPrice(transaction.getTransactionBalance());
                    receipt.setApprovalAmount(transaction.getTransactionBalance());
                    // receipt.setAuthNumber();    //null

                    receipt = receiptRepository.save(receipt);

                    if (transactionRepository.doesDummyRecordAlreadyExists(
                            userKeyAccountPair.getKakaoId(), location, transactionBalance)) {
                        List<Map<String, Object>> menuList =
                                (List<Map<String, Object>>) record.get("menuList");

                        for (Map<String, Object> menu : menuList) {
                            ReceiptDetail receiptDetail = new ReceiptDetail();

                            // receipt 레코드 FK 설정
                            receiptDetail.setReceipt(receipt);
                            receiptDetail.setMenu((String) menu.get("menu"));
                            receiptDetail.setCount(Integer.parseInt((String) menu.get("count")));
                            receiptDetail.setUnitPrice(
                                    Integer.parseInt((String) menu.get("unitPrice")));

                            receiptDetailRepository.save(receiptDetail);

                            // 테이블에 레코드 추가 후 삭제
                            // menuList.remove(menu);
                        }
                    }

                    // while문 탈출 조건
                    dummyRecords.remove(record);
                } else {
                    log.info("transaction 테이블에 관련 레코드 없음!");

                    throw new Exception();
                }
            }
        }
    }
}
