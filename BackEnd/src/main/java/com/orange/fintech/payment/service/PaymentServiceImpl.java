package com.orange.fintech.payment.service;

import com.orange.fintech.common.exception.RelatedTransactionNotFoundException;
import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupMemberPK;
import com.orange.fintech.group.repository.GroupMemberRepository;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.dto.*;
import com.orange.fintech.payment.entity.*;
import com.orange.fintech.payment.repository.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.UnexpectedRollbackException;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {

    private final MemberRepository memberRepository;
    private final GroupRepository groupRepository;
    private final TransactionRepository transactionRepository;
    private final TransactionQueryRepository transactionQueryRepository;
    private final TransactionDetailRepository transactionDetailRepository;
    private final TransactionMemberRepository transactionMemberRepository;
    private final ReceiptRepository receiptRepository;
    private final ReceiptDetailRepository receiptDetailRepository;
    private final ReceiptDetailMemberRepository receiptDetailMemberRepository;

    private final GroupQueryRepository groupQueryRepository;
    private final GroupMemberRepository groupMemberRepository;

    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public boolean addTransaction(String memberId, int groupId, AddCashTransactionReq req) {
        log.info("거래내역 추가 시작");
        Transaction transaction = new Transaction();
        transaction.setTransactionDate(req.getTransactionDate());
        transaction.setTransactionTime(req.getTransactionTime());
        transaction.setTransactionBalance(req.getTransactionBalance());
        transaction.setTransactionSummary(req.getTransactionSummary());
        transaction.setMember(memberRepository.findById(memberId).get());
        // transaction.setTransactionType("");
        // transaction.setTransactionTypeName("");
        if (req.getTransactionTime() != null && req.getTransactionDate() != null) {
            transaction.setTransactionTime(req.getTransactionTime());
            transaction.setTransactionDate(req.getTransactionDate());
        } else {
            transaction.setTransactionDate(LocalDate.now());
            transaction.setTransactionTime(LocalTime.now());
        }
        transactionRepository.save(transaction);
        log.info("거래내역 추가 끝");

        saveTransactionDetail(groupId, transaction, req);

        saveReceipt(transaction, req);

        for (TransactionMemberDto tm : req.getMemberList()) {
            addTransactionMember(transaction.getTransactionId(), tm);
        }

        return false;
    }

    @Override
    public void addTransactionMember(int transactionId, TransactionMemberDto dto) {
        TransactionMemberPK pk = new TransactionMemberPK();
        pk.setTransaction(transactionRepository.findById(transactionId).get());
        pk.setMember(memberRepository.findById(dto.getMemberId()).get());

        TransactionMember transactionMember = new TransactionMember();
        transactionMember.setTransactionMemberPK(pk);
        transactionMember.setTotalAmount(dto.getTotalAmount());
        //        transactionMember.setIsLock(dto.getIsLock());
        transactionMember.setIsLock(dto.isLock());

        transactionMemberRepository.save(transactionMember);

        log.info("transactionMemberDto {}", dto);
    }

    public void saveTransactionDetail(
            int groupId, Transaction transaction, AddCashTransactionReq req) {
        log.info("saveTransactionDetail 시작");
        TransactionDetail transactionDetail = new TransactionDetail();

        transactionDetail.setTransactionId(transaction.getTransactionId());
        transactionDetail.setGroup(groupRepository.findById(groupId).get());
        transactionDetail.setRemainder(req.getRemainder());
        transactionDetail.setReceiptEnrolled(false);

        log.info("saveTransactionDetail {}", transactionDetail);

        transactionDetailRepository.save(transactionDetail);
        log.info("saveTransactionDetail 끝");
    }

    public void saveReceipt(Transaction transaction, AddCashTransactionReq req) {
        log.info("saveReceipt 시작");
        Receipt receipt = new Receipt();
        receipt.setTransaction(transaction);
        receipt.setTotalPrice(Math.toIntExact(req.getTransactionBalance()));
        receipt.setApprovalAmount(Math.toIntExact(req.getTransactionBalance()));
        receipt.setLocation(req.getLocation());
        if (transaction.getTransactionDate() != null && transaction.getTransactionTime() != null) {
            receipt.setTransactionDate(transaction.getTransactionDate());
            receipt.setTransactionTime(transaction.getTransactionTime());
        } else {
            receipt.setTransactionDate(LocalDate.now());
            receipt.setTransactionTime(LocalTime.now());
        }

        receipt.setBusinessName(req.getTransactionSummary());
        receiptRepository.save(receipt);
        log.info("saveReceipt 끝");
    }

    @Override
    public List<TransactionDto> getMyTransaction(
            String memberId, int groupId, int page, int pageSize) {
        log.info("getMyTransaction start");

        Member member = memberRepository.findById(memberId).get();
        Group group = groupRepository.findById(groupId).get();

        List<TransactionDto> list =
                transactionQueryRepository.getMyTransactionByMemberAndGroup(
                        member, group, page, pageSize);
        log.info("getMyTransaction end ");

        return list;
    }

    @Override
    public boolean isMyTransaction(String memberId, int transactionId) {
        log.info("isMyTransaction: transactionId:{}", transactionId);
        Transaction transaction = transactionRepository.findById(transactionId).get();

        if (transaction.getMember().getKakaoId().equals(memberId)) {
            return true;
        }

        return false;
    }

    @Override
    public boolean isMyGroup(String memberId, int groupId) {
        Member member = memberRepository.findById(memberId).get();
        Group group = groupRepository.findById(groupId).get();

        GroupMemberPK pk = new GroupMemberPK(member, group);
        if (groupMemberRepository.existsById(pk)) {
            return true;
        }

        return false;
    }

    @Override
    public boolean isMyGroupTransaction(int groupId, int transactionId) {
        TransactionDetail transaction = transactionDetailRepository.findById(transactionId).get();

        if (transaction.getGroup().getGroupId() == groupId) {
            return true;
        }

        return false;
    }

    @Override
    public void changeContainStatus(int transactionId, int groupId) {
        Optional<Transaction> transactionOp = transactionRepository.findById(transactionId);

        if (transactionOp.isPresent()) {
            log.info("transactionOp present");
            Transaction transaction = transactionOp.get();
            Optional<TransactionDetail> td = transactionDetailRepository.findById(transactionId);

            //            if (td.isPresent()) {
            //                log.info("transactionOp detail present");
            //                log.info("td.get().getGroup() {}", td.get().getGroup());
            //            }

            TransactionDetail transactionDetail = null;
            if (td.isPresent()) {
                transactionDetail = td.get();
            } else {
                transactionDetail = new TransactionDetail();
                transactionDetail.setTransactionId(transactionId);
            }

            // 포함하기
            if (transactionDetail.getGroup() == null) {
                Group group = groupRepository.findById(groupId).get();

                // 포함하기
                transactionDetail.setGroup(group);

                // transactionMember 설정
                int headCount = groupMemberRepository.countByGroupMemberPKGroup(group);
                long individualAmount = transaction.getTransactionBalance() / headCount;

                log.info("individualAmount: {}", individualAmount);

                for (GroupMembersDto groupMember : groupQueryRepository.findGroupMembers(groupId)) {
                    TransactionMember tm = new TransactionMember();
                    TransactionMemberPK pk =
                            new TransactionMemberPK(
                                    transaction,
                                    memberRepository.findById(groupMember.getKakaoId()).get());
                    tm.setTransactionMemberPK(pk);
                    tm.setIsLock(false);
                    tm.setTotalAmount(individualAmount);
                    transactionMemberRepository.save(tm);
                }

                transactionDetail.setRemainder(
                        Math.toIntExact(transaction.getTransactionBalance()) % headCount);
            }
            // 제외하기
            else {
                for (GroupMembersDto groupMember : groupQueryRepository.findGroupMembers(groupId)) {
                    // transactionMember 낼 금액 0으로 설정
                    //                    TransactionMember transactionMember = new
                    // TransactionMember();
                    //                    TransactionMemberPK pk =
                    //                            new TransactionMemberPK(
                    //                                    transaction,
                    //
                    // memberRepository.findById(groupMember.getKakaoId()).get());
                    //                    transactionMember.setTransactionMemberPK(pk);
                    //                    transactionMember.setIsLock(false);
                    //                    transactionMember.setTotalAmount(0);
                    //                    transactionMemberRepository.save(transactionMember);

                    // transactionMember 컬럼 삭제
                    TransactionMemberPK pk =
                            new TransactionMemberPK(
                                    transaction,
                                    memberRepository.findById(groupMember.getKakaoId()).get());
                    TransactionMember transactionMember =
                            transactionMemberRepository.findById(pk).get();
                    transactionMemberRepository.delete(transactionMember);
                }

                transactionDetail.setRemainder(0);
                transactionDetail.setGroup(null);
            }

            log.info("transactionDetail : {}", transactionDetail);
            transactionDetailRepository.save(transactionDetail);
        } else {
            log.info("transaction not present");
            throw new RuntimeException();
        }
    }

    @Override
    public void editTransactionDetail(int transactionId, TransactionEditReq req)
            throws NoSuchElementException {
        TransactionDetail transactionDetail =
                transactionDetailRepository.findById(transactionId).get();

        transactionDetail.setMemo(req.getMemo());
        transactionDetailRepository.save(transactionDetail);

        Transaction transaction = transactionDetail.getTransaction();

        for (TransactionMemberDto dto : req.getMemberList()) {
            Member member = memberRepository.findById(dto.getMemberId()).get();

            TransactionMemberPK pk = new TransactionMemberPK();
            pk.setTransaction(transaction);
            pk.setMember(member);

            TransactionMember tm = transactionMemberRepository.findById(pk).get();
            tm.setTotalAmount(dto.getTotalAmount());
            tm.setIsLock(dto.isLock());
        }
    }

    @Override
    public TransactionDetailRes getTransactionDetail(int transactionId) {
        TransactionDetailRes res = transactionQueryRepository.getTransactionDetail(transactionId);

        Transaction transaction = transactionRepository.findById(transactionId).get();
        List<TransactionMember> transactionMembers =
                transactionMemberRepository.findByTransactionMemberPKTransaction(transaction);
        log.info("transactionMember : {}", transactionMembers);

        List<TransactionMemberDto> list = new ArrayList<>();
        for (TransactionMember m : transactionMembers) {
            list.add(TransactionMemberDto.of(m));
        }

        res.setMemberList(list);

        return res;
    }

    @Override
    public List<TransactionDto> getGroupTransaction(
            String memberId, int groupId, int page, int pageSize, String option) {

        log.info("service -- getGroupTransaction, memberId {}", memberId);

        return transactionQueryRepository.getGroupTransaction(
                groupRepository.findById(groupId).get(),
                page,
                pageSize,
                option,
                memberRepository.findById(memberId).get());
    }

    @Override
    public GroupTransactionDetailRes getGroupTransactionDetail(int transactionId) {
        Transaction transaction = transactionRepository.findById(transactionId).get();
        log.info("getGroupTransactionDetail - transaction: {}", transaction);

        Receipt receipt =
                receiptRepository.findByTransaction(
                        transactionRepository.findById(transactionId).get());
        log.info("getGroupTransactionDetail - receipt: {}", receipt);

        TransactionDetail transactionDetail =
                transactionDetailRepository.getReferenceById(transactionId);

        List<TransactionMember> list =
                transactionMemberRepository.findByTransactionMemberPKTransaction(transaction);
        log.info("getGroupTransactionDetail - List<TransactionMember> list: {}", list);

        return GroupTransactionDetailRes.of(receipt, list, transactionDetail);
    }

    @Override
    public ReceiptDto getGroupReceipt(int receiptId) {
        Receipt receipt = receiptRepository.findById(receiptId).get();
        return ReceiptDto.of(receipt);
    }

    @Override
    public ReceiptDetailRes getGroupReceiptDetail(int receiptDetailId) {
        ReceiptDetail receiptDetail = receiptDetailRepository.findById(receiptDetailId).get();
        List<ReceiptDetailMember> detailMemberList =
                receiptDetailMemberRepository.findByReceiptDetailMemberPKReceiptDetail(
                        receiptDetail);

        ReceiptDetailRes res = ReceiptDetailRes.of(receiptDetail, detailMemberList);

        return res;
    }

    @Override
    public void setReceiptDetailMember(
            int paymentId, int receiptDetailId, List<ReceiptDetailMemberPutDto> req)
            throws Exception {
        int payAmount = 0;
        int headCnt = req.size();

        Transaction transaction = transactionRepository.findById(paymentId).get();
        ReceiptDetail receiptDetail = receiptDetailRepository.findById(receiptDetailId).get();
        log.info("receiptDetail: {}", receiptDetail);

        Receipt receipt = receiptRepository.findByTransaction(transaction);

        int discount = 0;
        if (receipt.getApprovalAmount() != receipt.getTotalPrice()) {
            discount = receipt.getTotalPrice() - receipt.getApprovalAmount();
        }

        for (ReceiptDetailMemberPutDto detailMemberDto : req) {
            ReceiptDetailMemberPK pk = new ReceiptDetailMemberPK();

            Member member = new Member();
            member.setKakaoId(detailMemberDto.getMemberId());

            pk.setMember(member);
            pk.setReceiptDetail(receiptDetail);

            // pk.setMember(memberRepository.findById(detailMemberDto.getMemberId()).get());
            //            pk.setReceiptDetail(
            // receiptDetailRepository.findById(detailMemberDto.getReceiptDetailId()).get());

            ReceiptDetailMember detailMember = new ReceiptDetailMember();
            detailMember.setReceiptDetailMemberPK(pk);
            detailMember.setAmountDue(detailMemberDto.getAmountDue());

            receiptDetailMemberRepository.save(detailMember);

            TransactionMemberPK tmPk = new TransactionMemberPK();
            tmPk.setMember(member);
            tmPk.setTransaction(transaction);

            // transactionMember - totalAmount 설정
            TransactionMember transactionMember = transactionMemberRepository.findById(tmPk).get();
            int pay =
                    calculateTransactionMember(
                            member.getKakaoId(), receiptDetail.getReceipt().getReceiptId());
            payAmount += (pay - discount / headCnt);
            transactionMember.setTotalAmount((long) (pay - discount / headCnt));
            transactionMemberRepository.save(transactionMember);
        }

        // 자투리금액 계산
        TransactionDetail transactionDetail =
                transactionDetailRepository.findById(transaction.getTransactionId()).get();

        // SINYEONG: 예외처리?
        if (transaction.getTransactionBalance() >= payAmount) {
            transactionDetail.setRemainder((int) (transaction.getTransactionBalance() - payAmount));
        } else {
            throw new Exception();
        }

        log.info("remainder: {} - {}", transaction.getTransactionBalance(), payAmount);

        transactionDetailRepository.save(transactionDetail);
    }

    public int calculateTransactionMember(String memberId, int receiptId) {
        return transactionQueryRepository.getTransactionTotalAmount(memberId, receiptId);
    }

    @Override
    //    @Transactional(rollbackFor = Exception.class)
    //    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public void addSingleReceipt(String kakaoId, ReceiptRequestDto receiptRequestDto)
            throws RelatedTransactionNotFoundException {
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

            // 2-1. 업로드한 영수증에 해당하는 결제 정보 (Record)를 Transaction 테이블에서 찾을 수 없는 경우 예외 발생
            if (transaction == null) {
                throw new RelatedTransactionNotFoundException();
            }

            // 2-2. 업로드한 영수증에 해당하는 결제 정보 (Record)를 Transaction 테이블에서 찾는 경우

            // 3-1. Receipt테이블에서 Transaction 레코드를 FK로 가지는 레코드가 있는지 확인
            Receipt receipt = receiptRepository.findByTransaction(transaction);

            // 3-2. 레코드가 없으면 생성
            if (receipt == null) {
                receipt = new Receipt();
            }

            // 3-3. Receipt 레코드 업데이트
            receipt.setTransaction(transaction);
            receipt.setBusinessName(receiptRequestDto.getBusinessName());
            receipt.setSubName(receiptRequestDto.getSubName());
            receipt.setLocation(receiptRequestDto.getLocation());
            receipt.setTransactionDate(transactionDate);
            receipt.setTransactionTime(transactionTime);
            receipt.setTotalPrice(receiptRequestDto.getTotalPrice());
            receipt.setApprovalAmount(receiptRequestDto.getApprovalAmount());

            // 3-4. Receipt 테이블에 레코드 추가
            Receipt savedReceiptRecord =
                    receiptRepository.save(receipt); // 추가한 영수증 레코드 (PK 값이 지정되어 있음)

            // 4-1. 기존 ReceiptDetail 테이블의 레코드 삭제 (업데이트 대신 삭제 (메뉴 이름 변경))
            receiptDetailRepository.deleteRecordsByReceipt(receipt);
            receiptDetailRepository.flush(); // 즉시 삭제 (flush를 호출하지 않으면 새로 추가한 메뉴도 함께 삭제됨)

            // 4-2. ReceiptDetail 테이블에 레코드 추가
            List<ReceiptRequestDto.Item> items = receiptRequestDto.getItems();

            for (ReceiptRequestDto.Item item : items) {
                ReceiptDetail receiptDetail = new ReceiptDetail();
                receiptDetail.setReceipt(savedReceiptRecord);

                receiptDetail.setMenu(item.getName());
                receiptDetail.setCount(item.getCount());
                receiptDetail.setUnitPrice(item.getPrice() / item.getCount()); // 소수점 오차 생길 수 있음

                receiptDetailRepository.save(receiptDetail);
            }
        } catch (DataIntegrityViolationException | UnexpectedRollbackException e) {
            e.printStackTrace();
        }
    }

    @Override
    //    @Transactional(rollbackFor = Exception.class)
    //    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    //    @Transactional(rollbackFor = Exception.class, propagation = Propagation.NESTED)
    //    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void addMultipleReceipt(String kakaoId, List<ReceiptRequestDto> receiptRequestDtoList)
            throws RelatedTransactionNotFoundException {
        for (ReceiptRequestDto receiptRequestDto : receiptRequestDtoList) {
            try {
                addSingleReceipt(kakaoId, receiptRequestDto);
            } catch (RelatedTransactionNotFoundException e) {
                throw e;
            } catch (DataIntegrityViolationException
                    | UnexpectedRollbackException e) { // 중복 레코드 발생 -> 저장 스킵
            } catch (Exception e) {
            }
        }
    }
}
