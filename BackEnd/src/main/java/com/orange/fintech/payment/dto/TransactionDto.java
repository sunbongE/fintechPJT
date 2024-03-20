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

    @Schema(description = "거래내역 pk")
    private Integer transactionId;

    @Schema(description = "거래일자")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @Schema(description = "거래시각")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    @Schema(description = "1(입급), 2(출금)")
    private String transactionType;

    @Schema(description = "입금, 출금, 입금(이체), 출금(이체)")
    private String transactionTypeName;

    @Schema(description = "거래금액")
    private Long transactionBalance;

    @Schema(description = "거래후잔액")
    private Long transactionAfterBalance;

    @Schema(description = "거래요약내용")
    private String transactionSummary;

    @Schema(description = "포함된 그룹 id", example = "1")
    private Integer groupId;

    @Schema(description = "메모", example = "memo")
    private String memo;

    @Schema(description = "영수증 포함 여부", example = "false")
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
