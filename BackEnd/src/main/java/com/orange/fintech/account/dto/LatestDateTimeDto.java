package com.orange.fintech.account.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.payment.entity.Transaction;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
@Data
public class LatestDateTimeDto {

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    LocalDate transactionDate;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    LocalTime transactionTime;

    public LatestDateTimeDto(Transaction latestData) {
        this.transactionDate = latestData.getTransactionDate();
        this.transactionTime = latestData.getTransactionTime();
    }
}
