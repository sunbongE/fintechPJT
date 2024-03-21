package com.orange.fintech.payment.service;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.TransactionMemberDto;
import com.orange.fintech.payment.dto.TransactionPostReq;
import com.orange.fintech.payment.entity.*;
import com.orange.fintech.payment.repository.*;
import java.time.LocalDateTime;
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
    private final TransactionQueryRepository transactionRepositorySupport;
    private final TransactionDetailRepository transactionDetailRepository;
    private final TransactionMemberRepository transactionMemberRepository;

    private final ReceiptRepository receiptRepository;

    @Override
    public boolean addTransaction(int groupId, TransactionPostReq req) {
        log.info("거래내역 추가 시작");
        Transaction transaction = new Transaction();
        transaction.setTransactionDate(req.getTransactionDate());
        transaction.setTransactionTime(req.getTransactionTime());
        transaction.setTransactionBalance(req.getTransactionBalance());
        transaction.setTransactionSummary(req.getTransactionSummary());
        // transaction.setTransactionType("");
        // transaction.setTransactionTypeName("");
        transactionRepository.save(transaction);
        log.info("거래내역 추가 끝");

        saveTransactionDetail(groupId, transaction, req);

        saveReceipt(transaction, req);

        for (TransactionMemberDto tm : req.getMemberList()) {
            addTransactionMember(groupId, tm);
        }

        return false;
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
        receipt.setDateTime(LocalDateTime.of(req.getTransactionDate(), req.getTransactionTime()));
        receipt.setBusinessName(req.getTransactionSummary());
        receiptRepository.save(receipt);
        log.info("saveReceipt 끝");
    }

    @Override
    public List<TransactionDto> getMyTransaction(String memberId, int groupId) {
        log.info("getMyTransaction start");

        Member member = memberRepository.findById(memberId).get();
        Group group = groupRepository.findById(groupId).get();

        List<TransactionDto> list =
                transactionRepositorySupport.getTransactionByMemberAndGroup(member, group);
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
}
