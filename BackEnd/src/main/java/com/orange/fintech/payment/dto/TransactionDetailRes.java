package com.orange.fintech.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "거래내역 상세 Dto")
public class TransactionDetailRes {

    @Schema(description = "거래일자")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @Schema(description = "거래시각")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    @Schema(description = "거래금액")
    private Long transactionBalance;

    @Schema(description = "거래요약내용")
    private String transactionSummary;

    @Schema(description = "메모", example = "memo")
    private String memo;

    @Schema(description = "자투리 금액")
    private Integer remainder;

    @Schema(description = "영수증 포함 여부", example = "false")
    private boolean receiptEnrolled;

    @Schema(description = "거래 멤버 리스트")
    private List<TransactionMemberDto> memberList;
}
