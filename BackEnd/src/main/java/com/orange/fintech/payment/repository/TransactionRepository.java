package com.orange.fintech.payment.repository;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.entity.Transaction;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {

}
