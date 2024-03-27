package com.orange.fintech.account.dto;

import lombok.Data;

@Data
public class DepositsAndWithdrawalsDto {
    // 거래 내역에 DTO
    String transactionType;
    String transactionAfterBalance;
    String transactionUniqueNo;
    String transactionBalance;
    String transactionSummary;
    String transactionDate;
    String transactionTime;
    String transactionTypeName;

}
