package com.orange.fintech.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "거래내역 Dto")
public class TransactionDto {

    private Integer transactionId;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    private String transactionType;

    private String transactionTypeName;

    private Long transactionBalance;

    private Long transactionAfterBalance;

    private String transactionSummary;

    @Schema(example = "1")
    private Integer groupId;

    @Schema(example = "memo")
    private String memo;

    @Schema(example = "false")
    private boolean receiptEnrolled;

    @Override
    public String toString() {
        return "TransactionDto{"
                + "transactionId="
                + transactionId
                + ", groupId="
                + groupId
                + ", transactionDate="
                + transactionDate
                + ", transactionTime="
                + transactionTime
                + ", transactionType='"
                + transactionType
                + '\''
                + ", transactionTypeName='"
                + transactionTypeName
                + '\''
                + ", transactionBalance="
                + transactionBalance
                + ", transactionAfterBalance="
                + transactionAfterBalance
                + ", transactionSummary='"
                + transactionSummary
                + '\''
                + ", memo='"
                + memo
                + '\''
                + ", receiptEnrolled="
                + receiptEnrolled
                + '}';
    }
}
