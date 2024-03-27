package com.orange.fintech.payment.dto;

import lombok.Data;

@Data
public class TransactionResDto {

    String transactionType;
    String transactionAfterBalance;
    String transactionUniqueNo;
    String transactionBalance;
    String transactionSummary;
    String transactionDate;
    String transactionTime;
    String transactionTypeName;
}
