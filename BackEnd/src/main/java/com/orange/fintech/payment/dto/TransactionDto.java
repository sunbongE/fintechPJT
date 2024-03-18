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
@Schema(name = "거래내역", description = "거래내역 Dto")
public class TransactionDto {

    @Schema(name = "transaction id", example = "1")
    private Integer transactionId;

    @Schema(name = "group id", example = "1")
    private Integer groupId;

    private Integer transactionUniqueNo;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    private String transactionType;

    private String transactionTypeName;

    private Long transactionBalance;

    private Long transactionAfterBalance;

    private String transactionSummary;

    @Schema(name = "memo", example = "memo")
    private String memo;

    @Schema(name = "영수증 등록 여부", example = "false")
    private boolean receiptEnrolled;

    @Override
    public String toString() {
        return "TransactionDto{"
                + "transactionId="
                + transactionId
                + ", groupId="
                + groupId
                + ", transactionUniqueNo="
                + transactionUniqueNo
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
