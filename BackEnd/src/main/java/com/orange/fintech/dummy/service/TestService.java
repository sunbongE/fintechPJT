package com.orange.fintech.dummy.service;

import com.amazonaws.services.s3.AmazonS3;
import com.orange.fintech.account.dto.ReqHeader;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.repository.AccountQueryRepository;
import com.orange.fintech.account.repository.AccountRepository;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.dummy.dto.UserKeyAccountPair;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.ReceiptDetail;
import com.orange.fintech.payment.entity.Transaction;
import com.orange.fintech.payment.entity.TransactionDetail;
import com.orange.fintech.payment.repository.ReceiptDetailRepository;
import com.orange.fintech.payment.repository.ReceiptRepository;
import com.orange.fintech.payment.repository.TransactionDetailRepository;
import com.orange.fintech.payment.repository.TransactionRepository;
import com.orange.fintech.util.AccountDateTimeUtil;
import com.orange.fintech.util.FileService;
import com.orange.fintech.util.FileUtil;
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
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@Transactional
public class TestService {
    @Autowired AccountService accountService;

    @Autowired FileService fileService;

    @Autowired MemberRepository memberRepository;

    @Autowired TransactionRepository transactionRepository;

    @Autowired TransactionDetailRepository transactionDetailRepository;

    @Autowired AccountQueryRepository accountQueryRepository;

    @Autowired AccountRepository accountRepository;

    @Autowired ReceiptRepository receiptRepository;

    @Autowired ReceiptDetailRepository receiptDetailRepository;

    @Autowired GroupRepository groupRepository;

    @Autowired FileUtil fileUtil;

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

    @Autowired AmazonS3 amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public void loadData(MultipartFile csvFile) throws Exception {
        String line;

        // 1. 업로드 한 파일이 비어있는지 확인
        if (csvFile.isEmpty()) {
            throw new Exception("Empty file -TestServiceImpl.java");
        }

        File convertedFile = fileUtil.multipartFile2File(csvFile);

        // File이 없으면 예외 발생
        if (!convertedFile.exists()) {
            throw new FileNotFoundException();
        }

        // File이 있으면 List 초기화 후 다시 넣음
        dummyRecords.clear();

        try (BufferedReader br =
                new BufferedReader(new InputStreamReader(new FileInputStream(convertedFile)))) {
            // 한 줄 (제목 행) 버리기
            Map<String, Object> map = new HashMap<>();
            Map<String, Object> menuMap = new HashMap<>();
            List<Map<String, Object>> menuList = new ArrayList<>();
            line = br.readLine();

            while ((line = br.readLine()) != null) {
                String[] tokens = line.split(",");
                log.info("line: {}", line);

                if (tokens.length == 0) {
                    dummyRecords.add(map);
                    map.put("menuList", menuList);

                    map = new HashMap<>();
                    menuList = new ArrayList<>();
                } else if (tokens.length == 9) {
                    // 7: 주소, 8: 금액
                    map.put("payer", tokens[1]);
                    log.info("payer: {}", tokens[1]);
                    map.put("storeName", tokens[2]);
                    log.info("storeName: {}", tokens[2]);
                    map.put("location", tokens[7]);
                    log.info("location: {}", tokens[7]);
                    map.put("approvalAmount", tokens[8]);
                    log.info("approvalAmount: {}", tokens[8]);
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

        // MultipartFile -> File로 변환하면서 로컬에 저장된 파일 삭제
        removeFile(convertedFile);
    }

    public void removeFile(File targetFile) { // 로컬파일 삭제
        if (targetFile.exists()) {
            if (targetFile.delete()) {
                // System.out.println("파일이 삭제되었습니다.");
            } else {
                // System.out.println("파일이 삭제되지 못했습니다.");
            }
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
    public void refreshBeforeTransactionUsingSSAFYAPI(
            List<UserKeyAccountPair> userKeyAccountPairList) throws Exception {
        // 관심있는 계좌의 거래 내역만 갱신 (userKeyAccountPairList.get().getAccountNo())
        for (int i = 0; i < userKeyAccountPairList.size(); i++) {
            UserKeyAccountPair userKeyAccountPair = userKeyAccountPairList.get(i);
            Member member = memberRepository.findByKakaoId(userKeyAccountPair.getKakaoId());
            String startDate = "";
            String endDate = "20241231";

            ReqHeader reqHeader =
                    accountService.createHeader(
                            userKeyAccountPair.getUserKey(), transactionHistoryUrl);

            // 새로운 계좌 등록
            Account account = null;
            account =
                    accountRepository.findAccountByAccountNoAndKakaoId(
                            userKeyAccountPair.getAccountNo(), userKeyAccountPair.getKakaoId());
            LocalTime startTime = null;

            if (account == null) {
                account = new Account();

                account.setMember(memberRepository.findByKakaoId(userKeyAccountPair.getKakaoId()));
                account.setBalance(0L);
                account.setIsPrimaryAccount(false);
                account.setBankCode("001");
                log.info(
                        "userKeyAccountPair.getAccountNo(): {}", userKeyAccountPair.getAccountNo());
                account.setAccountNo(userKeyAccountPair.getAccountNo());
                log.info("저장할 account 객체: {}", account.toString());

                accountRepository.save(account);
                // FIXME
                accountRepository.flush();

                startDate = "20240101";
            } else {
                List<Transaction> transactionList =
                        transactionRepository.findAccountByAccountNoAndKakaoId(
                                userKeyAccountPair.getAccountNo(),
                                userKeyAccountPair.getKakaoId(),
                                PageRequest.of(0, 1));
                ;
                Transaction transaction = null;

                LocalDate transactionDate = null;
                LocalTime transactionTime = null;

                if (!transactionList.isEmpty()) {
                    transaction = transactionList.get(0);

                    transactionDate = transaction.getTransactionDate();
                    transactionTime = transaction.getTransactionTime();
                } else {
                    // Do nothing
                }

                startDate = AccountDateTimeUtil.localDateToString(transaction.getTransactionDate());
                startTime = transaction.getTransactionTime();
            }

            LocalDate startDate_LocalDate = AccountDateTimeUtil.StringToLocalDate(startDate);
            LocalTime startTime_LocalTime = startTime;

            Map<String, Object> req = new HashMap<>();
            req.put("Header", reqHeader);
            req.put("bankCode", bankCode);
            req.put("accountNo", userKeyAccountPair.getAccountNo());
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
            JSONObject REC = (JSONObject) jsonObject.get("REC");
            JSONArray jsonArray = (JSONArray) REC.get("list");

            List<Transaction> saveDataList = new ArrayList<>();

            if (jsonArray != null) {
                for (Object element : jsonArray) {
                    JSONObject tmp = (JSONObject) element;

                    LocalDate transactionDate =
                            AccountDateTimeUtil.StringToLocalDate(
                                    tmp.get("transactionDate").toString());
                    LocalTime transactionTime =
                            AccountDateTimeUtil.StringToLocalTime(
                                    tmp.get("transactionTime").toString());

                    if (transactionDate.isAfter(startDate_LocalDate)
                            || (transactionDate.isEqual(startDate_LocalDate)
                                    && transactionTime.isAfter(startTime_LocalTime))) {
                        Transaction transaction = new Transaction(tmp, account, member);

                        if (tmp.get("transactionTypeName").equals("출금(이체)")
                                || tmp.get("transactionTypeName").equals("입금(이체)")) {
                            transaction.setTransactionAccountNo(
                                    tmp.get("transactionAccountNo").toString());
                        }
                        saveDataList.add(transaction);
                    }
                }

                // account 잔액 새로고침
                JSONObject firstRecord = (JSONObject) jsonArray.get(0);
                int transactionAfterBalance =
                        Integer.parseInt((String) firstRecord.get("transactionAfterBalance"));
                account.setBalance(Long.valueOf(transactionAfterBalance));
            }

            // 저장할 데이터가 있으면 저장.
            if (!saveDataList.isEmpty()) {
                List<Transaction> savedAll = transactionRepository.saveAll(saveDataList);

                // 디테일 생성.
                List<TransactionDetail> transactionDetailList = new ArrayList<>();
                for (Transaction data : savedAll) {
                    TransactionDetail detail = new TransactionDetail();
                    // 그룹 번호 지정
                    detail.setTransactionId(data.getTransactionId());
                    transactionDetailList.add(detail);
                }
                transactionDetailRepository.saveAll(transactionDetailList);
            }
        }
    }

    // 그룹원의 거래 내역 갱신 (SSAFY Bank API를 호출하여 서비스 서버의 Transaction 테이블 갱신)
    public void refreshAfterTransactionUsingSSAFYAPI(
            int groupId, List<UserKeyAccountPair> userKeyAccountPairList) throws Exception {
        // 관심있는 계좌의 거래 내역만 갱신 (userKeyAccountPairList.get().getAccountNo())
        for (int i = 0; i < userKeyAccountPairList.size(); i++) {
            UserKeyAccountPair userKeyAccountPair = userKeyAccountPairList.get(i);
            Member member = memberRepository.findByKakaoId(userKeyAccountPair.getKakaoId());
            String startDate = "";
            String endDate = "20241231";

            ReqHeader reqHeader =
                    accountService.createHeader(
                            userKeyAccountPair.getUserKey(), transactionHistoryUrl);

            // 새로운 계좌 등록
            Account account = null;
            account =
                    accountRepository.findAccountByAccountNoAndKakaoId(
                            userKeyAccountPair.getAccountNo(), userKeyAccountPair.getKakaoId());
            LocalTime startTime = null;

            if (account == null) {
                account = new Account();

                account.setAccountNo(userKeyAccountPair.getAccountNo());
                account.setMember(memberRepository.findByKakaoId(userKeyAccountPair.getKakaoId()));
                account.setBalance(0L);

                accountRepository.save(account);

                startDate = "20240101";
            } else {
                List<Transaction> transactionList =
                        transactionRepository.findAccountByAccountNoAndKakaoId(
                                userKeyAccountPair.getAccountNo(),
                                userKeyAccountPair.getKakaoId(),
                                PageRequest.of(0, 1));
                ;
                Transaction transaction = null;

                LocalDate transactionDate = null;
                LocalTime transactionTime = null;

                if (!transactionList.isEmpty()) {
                    transaction = transactionList.get(0);

                    transactionDate = transaction.getTransactionDate();
                    transactionTime = transaction.getTransactionTime();
                } else {
                    // Do nothing
                }

                startDate = AccountDateTimeUtil.localDateToString(transaction.getTransactionDate());
                startTime = transaction.getTransactionTime();
            }

            LocalDate startDate_LocalDate = AccountDateTimeUtil.StringToLocalDate(startDate);
            LocalTime startTime_LocalTime = startTime;

            Map<String, Object> req = new HashMap<>();
            req.put("Header", reqHeader);
            req.put("bankCode", bankCode);
            req.put("accountNo", userKeyAccountPair.getAccountNo());
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
            JSONObject REC = (JSONObject) jsonObject.get("REC");
            JSONArray jsonArray = (JSONArray) REC.get("list");

            List<Transaction> saveDataList = new ArrayList<>();

            if (jsonArray != null) {
                for (Object element : jsonArray) {
                    JSONObject tmp = (JSONObject) element;

                    LocalDate transactionDate =
                            AccountDateTimeUtil.StringToLocalDate(
                                    tmp.get("transactionDate").toString());
                    LocalTime transactionTime =
                            AccountDateTimeUtil.StringToLocalTime(
                                    tmp.get("transactionTime").toString());

                    if (transactionDate.isAfter(startDate_LocalDate)
                            || (transactionDate.isEqual(startDate_LocalDate)
                                    && transactionTime.isAfter(startTime_LocalTime))) {
                        Transaction transaction = new Transaction(tmp, account, member);

                        if (tmp.get("transactionTypeName").equals("출금(이체)")
                                || tmp.get("transactionTypeName").equals("입금(이체)")) {
                            transaction.setTransactionAccountNo(
                                    tmp.get("transactionAccountNo").toString());
                        }
                        saveDataList.add(transaction);
                    }
                }

                // account 잔액 새로고침
                JSONObject firstRecord = (JSONObject) jsonArray.get(0);
                int transactionAfterBalance =
                        Integer.parseInt((String) firstRecord.get("transactionAfterBalance"));
                account.setBalance(Long.valueOf(transactionAfterBalance));
            }

            // 저장할 데이터가 있으면 저장.
            if (!saveDataList.isEmpty()) {
                List<Transaction> savedAll = transactionRepository.saveAll(saveDataList);

                // 디테일 생성.
                List<TransactionDetail> transactionDetailList = new ArrayList<>();
                for (Transaction data : savedAll) {
                    TransactionDetail detail = new TransactionDetail();
                    // TODO: 그룹 번호 지정

                    // 그룹 번호 지정
                    detail.setGroup(groupRepository.findById(groupId).get());
                    detail.setTransactionId(data.getTransactionId());
                    transactionDetailList.add(detail);
                }
                transactionDetailRepository.saveAll(transactionDetailList);
            }
        }
    }

    public void postDummyTranaction(
            int groupId, MultipartFile csvFile, List<UserKeyAccountPair> userKeyAccountPairList)
            throws Exception {
        UserKeyAccountPair userKeyAccountPair = null;

        if (userKeyAccountPairList.size() != groupMemberCount) {

            throw new Exception();
        }

        // 1. 그룹원의 거래 내역 갱신 (SSAFY Bank API를 호출하여 서비스 서버의 Transaction 테이블 갱신)
        refreshBeforeTransactionUsingSSAFYAPI(userKeyAccountPairList);

        // 2. 잔액 충전
        for (int i = 0; i < groupMemberCount; i++) {
            userKeyAccountPair = userKeyAccountPairList.get(i);

            // 잔액 충전 (오백만원)
            accountService.deposit(
                    userKeyAccountPair.getUserKey(), userKeyAccountPair.getAccountNo(), 5_000_000L);
        }

        // 3. 더미 레코드가 저장된 CSV 파일 로드
        loadData(csvFile);

        // 4. SSAFY Bank API를 호출
        for (int i = 0; i < dummyRecords.size(); i++) {
            Map<String, Object> dummyRecord = dummyRecords.get(i);

            // userKeyAccountPair 재 대입
            int payerIndex = Integer.parseInt(dummyRecord.get("payer").toString()) - 1;
            userKeyAccountPair = userKeyAccountPairList.get(payerIndex);
            Long balance = Long.valueOf(dummyRecord.get("approvalAmount").toString());
            String transactionSummary = dummyRecord.get("storeName").toString();

            HttpStatusCode statusCode = null;
            long start, now;

            do {
                ReqHeader reqHeader =
                        accountService.createHeader(
                                userKeyAccountPair.getUserKey(), drawingTransferUrl);

                reqHeader.setInstitutionTransactionUniqueNo(randomGenerator()); // 기관고유번호 교체
                start = System.currentTimeMillis();
                // 거래 내역이 없으면 SSAFY Bank API를 호출
                // 4-1. SSAFY Bank API 호출을 위한 Body 객체 생성
                Map<String, Object> requestBody = new HashMap<>();

                // 4-2. 'Body에 넣을' Header value 객체 생성 및 추가
                requestBody.put("Header", reqHeader);

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
            //            }
        }

        // 5. 그룹원의 거래 내역 갱신 (SSAFY Bank API를 호출하여 서비스 서버의 Transaction 테이블 갱신)
        refreshAfterTransactionUsingSSAFYAPI(groupId, userKeyAccountPairList);

        // 6. receipt와 receipt_detail 테이블에 레코드 추가
        for (Map<String, Object> record : dummyRecords) {
            // 테이블에 레코드 추가 후 삭제
            String storeName = (String) record.get("storeName");
            String location = (String) record.get("location");
            int payer = Integer.parseInt((String) record.get("payer")) - 1; // 1부터 시작이므로 -1
            Long transactionBalance = Long.parseLong((String) record.get("approvalAmount"));
            LocalDate transactionDate = LocalDate.now();

            // 일치하는 레코드 발견
            List<Transaction> transactionList =
                    transactionRepository.findDummyTargetReceipt(
                            transactionBalance, transactionDate, PageRequest.of(0, 1));
            Transaction transaction = transactionList.get(0);
            Receipt receipt = null;

            if (transaction != null) {
                receipt = receiptRepository.findByTransaction(transaction);

                if (receipt == null) {
                    receipt = new Receipt();
                }

                receipt.setTransaction(transaction);
                receipt.setBusinessName(storeName);
                // receipt.setSubName();   //null
                receipt.setLocation(location);
                receipt.setTransactionDate(transaction.getTransactionDate());
                receipt.setTransactionTime(transaction.getTransactionTime());
                receipt.setTotalPrice(transaction.getTransactionBalance());
                receipt.setApprovalAmount(transaction.getTransactionBalance());
                // receipt.setAuthNumber();    //null

                try {
                    receipt = receiptRepository.save(receipt);
                } catch (DataIntegrityViolationException e) {
                    e.printStackTrace();
                }
                List<Map<String, Object>> menuList =
                        (List<Map<String, Object>>) record.get("menuList");

                for (Map<String, Object> menu : menuList) {
                    ReceiptDetail receiptDetail = new ReceiptDetail();

                    // receipt 레코드 FK 설정
                    receiptDetail.setReceipt(receipt);
                    receiptDetail.setMenu((String) menu.get("menu"));
                    receiptDetail.setCount(Integer.parseInt((String) menu.get("count")));
                    receiptDetail.setUnitPrice(Integer.parseInt((String) menu.get("unitPrice")));

                    receiptDetailRepository.save(receiptDetail);
                }
            }
        }
    }
}
