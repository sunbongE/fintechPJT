package com.orange.fintech.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
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
@Schema(description = "거래내역 상세 Dto")
public class TransactionDetailDto {

    @Schema(description = "거래일자")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @Schema(description = "거래시각")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;
}
