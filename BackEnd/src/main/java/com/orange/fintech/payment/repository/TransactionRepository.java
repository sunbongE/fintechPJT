package com.orange.fintech.payment.repository;

import com.orange.fintech.payment.entity.Transaction;
import java.time.LocalDate;
import java.time.LocalTime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {
    @Query(
            "SELECT t FROM Transaction t WHERE t.transactionDate = :transactionDate AND t.transactionTime = :transactionTime AND t.member.kakaoId = :kakaoId")
    Transaction findReceiptApostropheForeignkey(
            @Param("transactionDate") LocalDate transactionDate,
            @Param("transactionTime") LocalTime transactionTime,
            String kakaoId);

    @Query(
            "SELECT EXISTS(SELECT t FROM Transaction t WHERE t.member.kakaoId = :kakaoId AND t.transactionBalance = :balance AND t.transactionSummary = :transactionSummary)")
    boolean doesDummyRecordAlreadyExists(
            @Param("kakaoId") String kakaoId,
            @Param("transactionSummary") String transactionSummary,
            @Param("balance") Long balance);
}
