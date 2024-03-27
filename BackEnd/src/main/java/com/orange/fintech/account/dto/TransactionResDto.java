package com.orange.fintech.account.dto;

import com.orange.fintech.payment.entity.Transaction;
import lombok.Data;

@Data
public class TransactionResDto {
    // 이체 DTO
    String transactionType;
    Long transactionAfterBalance;
    Integer transactionUniqueNo;
    String transactionAccountNo; // 거래했던 계좌번호 입금이거나 출금이 아닌경우.
    Long transactionBalance;
    String transactionSummary;
    String transactionDate;
    String transactionTime;
    String transactionTypeName;

    public TransactionResDto(Transaction transaction) {
        if (!transaction.getTransactionType().equals("입금")
                || !transaction.getTransactionType().equals("출금")) {
            this.transactionAccountNo = transaction.getTransactionAccountNo();
        }
        this.transactionAfterBalance = transaction.getTransactionAfterBalance();
        this.transactionBalance = transaction.getTransactionBalance();
        this.transactionUniqueNo = transaction.getTransactionUniqueNo();
        this.transactionSummary = transaction.getTransactionSummary();
        this.transactionDate = String.valueOf(transaction.getTransactionDate());
        this.transactionTime = String.valueOf(transaction.getTransactionTime());
        this.transactionTypeName = transaction.getTransactionTypeName();
        this.transactionType = transaction.getTransactionType();
    }
}
