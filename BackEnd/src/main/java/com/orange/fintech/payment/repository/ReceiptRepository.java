package com.orange.fintech.payment.repository;

import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReceiptRepository extends JpaRepository<Receipt, Integer> {

    Receipt findByTransaction(Transaction transaction);
}
