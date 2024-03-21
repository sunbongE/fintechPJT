package com.orange.fintech.payment.service;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.dto.TransactionDetailRes;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.TransactionMemberDto;
import com.orange.fintech.payment.dto.TransactionPostReq;
import com.orange.fintech.payment.entity.*;
import com.orange.fintech.payment.repository.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Transactional
@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {

    private final MemberRepository memberRepository;
    private final GroupRepository groupRepository;
    private final TransactionRepository transactionRepository;
    private final TransactionQueryRepository transactionQueryRepository;
    private final TransactionDetailRepository transactionDetailRepository;
    private final TransactionMemberRepository transactionMemberRepository;

    private final ReceiptRepository receiptRepository;

    @Override
    public boolean addTransaction(String memberId, int groupId, TransactionPostReq req) {
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
            int groupId, Transaction transaction, TransactionPostReq req) {
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

    public void saveReceipt(Transaction transaction, TransactionPostReq req) {
        log.info("saveReceipt 시작");
        Receipt receipt = new Receipt();
        receipt.setTransaction(transaction);
        receipt.setTotalPrice(Math.toIntExact(req.getTransactionBalance()));
        receipt.setApprovalAmount(Math.toIntExact(req.getTransactionBalance()));
        receipt.setLocation(req.getLocation());
        if (transaction.getTransactionDate() != null && transaction.getTransactionTime() != null) {
            receipt.setDateTime(
                    LocalDateTime.of(
                            transaction.getTransactionDate(), transaction.getTransactionTime()));
        } else {
            receipt.setDateTime(LocalDateTime.now());
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
        Transaction transaction = transactionRepository.findById(transactionId).get();

        if (transaction.getMember().getKakaoId().equals(memberId)) {
            return true;
        }

        return false;
    }

    @Override
    public boolean changeContainStatus(int transactionId, int groupId) {
        Optional<Transaction> transaction = transactionRepository.findById(transactionId);

        if (transaction.isPresent()) {
            log.info("transaction present");
            Optional<TransactionDetail> td = transactionDetailRepository.findById(transactionId);

            if (td.isPresent()) {
                log.info("transaction detail present");
                log.info("td.get().getGroup() {}", td.get().getGroup());

                if (td.get().getGroup() == null) {
                    td.get().setGroup(groupRepository.findById(groupId).get());
                } else {
                    td.get().setGroup(null);
                }

                transactionDetailRepository.save(td.get());
                return true;
            }
        } else {
            log.info("transaction not present");
        }

        return false;
    }

    @Override
    public void memo(int transactionId, String memo) throws NoSuchElementException {
        TransactionDetail transactionDetail =
                transactionDetailRepository.findById(transactionId).get();

        transactionDetail.setMemo(memo);
        transactionDetailRepository.save(transactionDetail);
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
            String memgerId, int groupId, int page, int pageSize, String option) {

        log.info("service -- getGroupTransaction, memberId {}", memgerId);

        return transactionQueryRepository.getGroupTransaction(
                groupRepository.findById(groupId).get(),
                page,
                pageSize,
                option,
                memberRepository.findById(memgerId).get());
    }
}
