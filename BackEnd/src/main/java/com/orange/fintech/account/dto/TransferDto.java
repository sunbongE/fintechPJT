package com.orange.fintech.account.dto;

import lombok.Data;

@Data
public class TransferDto {
    // 이체 DTO
    String transactionType;
    String transactionAfterBalance;
    String transactionUniqueNo;
    String transactionAccountNo; // 거래했던 계좌번호
    String transactionBalance;
    String transactionSummary;
    String transactionDate;
    String transactionTime;
    String transactionTypeName;
}
