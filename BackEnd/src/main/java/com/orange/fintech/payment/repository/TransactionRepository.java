package com.orange.fintech.payment.repository;

import com.orange.fintech.payment.entity.Transaction;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {
    // 기존 영수증 로직 (초 단위까지 비교)
    @Query(
            "SELECT t FROM Transaction t WHERE t.transactionDate = :transactionDate AND t.transactionTime = :transactionTime AND t.member.kakaoId = :kakaoId")
    Transaction findExactReceiptApostropheForeignkey(
            @Param("transactionDate") LocalDate transactionDate,
            @Param("transactionTime") LocalTime transactionTime,
            String kakaoId);

    // 임시 영수증 로직 (시(hour) 단위까지 비교)
    @Query(
            "SELECT t FROM Transaction t WHERE t.transactionDate = :transactionDate AND TIME_FORMAT(t.transactionTime, '%H') = TIME_FORMAT(:transactionTime, '%H') AND t.member.kakaoId = :kakaoId")
    Transaction findApproximateReceiptComparingHourApostropheForeignkey(
            @Param("transactionDate") LocalDate transactionDate,
            @Param("transactionTime") LocalTime transactionTime,
            String kakaoId);

    // 새로운 영수증 로직 (날짜와 금액 비교)
    @Query(
            "SELECT t FROM Transaction t WHERE t.transactionBalance = :transactionBalance AND t.transactionDate = :transactionDate AND t.member.kakaoId = :kakaoId ORDER BY t.transactionDate DESC, t.transactionTime DESC")
    //    Transaction findApproximateReceiptComparingBalanceApostropheForeignkey(
    List<Transaction> findApproximateReceiptComparingBalanceApostropheForeignkey(
            @Param("transactionBalance") Long transactionBalance,
            @Param("transactionDate") LocalDate transactionDate,
            @Param("kakaoId") String kakaoId,
            Pageable pagable);

    // 새로운 영수증 로직 (날짜와 금액 비교)
    @Query(
            "SELECT t FROM Transaction t WHERE t.transactionBalance = :transactionBalance AND t.transactionDate = :transactionDate")
    List<Transaction> findDummyTargetReceipt(
            @Param("transactionBalance") Long transactionBalance,
            @Param("transactionDate") LocalDate transactionDate,
            Pageable pagable);

    @Query(
            "SELECT EXISTS(SELECT t FROM Transaction t WHERE t.member.kakaoId = :kakaoId AND t.transactionBalance = :balance AND t.transactionSummary = :transactionSummary)")
    boolean doesDummyRecordAlreadyExists(
            @Param("kakaoId") String kakaoId,
            @Param("transactionSummary") String transactionSummary,
            @Param("balance") Long balance);

    // JPQL LIMIT 사용 불가 -> Pageable pagable 사용
    @Query(
            "SELECT t FROM Transaction t WHERE t.account.accountNo = :accountId AND t.member.kakaoId = :kakaoId ORDER BY t.transactionDate DESC, t.transactionTime DESC")
    List<Transaction> findAccountByAccountNoAndKakaoId(
            @Param("accountId") String accountId,
            @Param("kakaoId") String kakaoId,
            Pageable pagable);
}
