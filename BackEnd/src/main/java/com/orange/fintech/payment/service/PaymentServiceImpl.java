package com.orange.fintech.payment.service;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.entity.Transaction;
import com.orange.fintech.payment.entity.TransactionDetail;
import com.orange.fintech.payment.repository.TransactionDetailRepository;
import com.orange.fintech.payment.repository.TransactionRepository;
import com.orange.fintech.payment.repository.TransactionRepositorySupport;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired private TransactionRepository transactionRepository;
    @Autowired private TransactionRepositorySupport transactionRepositorySupport;
    @Autowired private TransactionDetailRepository transactionDetailRepository;

    @Autowired private MemberRepository memberRepository;

    @Autowired private GroupRepository groupRepository;

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
            Optional<TransactionDetail> td =
                    transactionDetailRepository.findById(transaction.get().getTransactionId());

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
}
