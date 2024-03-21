package com.orange.fintech.payment.repository;

import com.orange.fintech.payment.entity.Transaction;
import com.orange.fintech.payment.entity.TransactionMember;
import com.orange.fintech.payment.entity.TransactionMemberPK;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionMemberRepository
        extends JpaRepository<TransactionMember, TransactionMemberPK> {

    List<TransactionMember> findByTransactionMemberPKTransaction(Transaction transaction);
}
