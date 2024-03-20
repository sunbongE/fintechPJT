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
@Schema(description = "현금 결제 내역 추가 Dto")
public class TransactionPostReq {

    @Schema(description = "제목", example = "초돈")
    private String transactionSummary;

    @Schema(description = "장소", example = "광주광역시 ...")
    private String location;

    @Schema(description = "가격", example = "5000")
    private Long transactionBalance;

    @Schema(description = "결제 날짜", example = "2024-03-20")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @Schema(description = "결제 시간", example = "22:01:01")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    // SINYEONG
    @Schema(description = "현금 계산에 참여하는 사람 목록 (id, 금액, 잠금)")
    private List<TransactionMemberDto> memberList;

    @Schema(description = "자투리 금액")
    private int remainder;

    @Override
    public String toString() {
        return "TransactionPostReq{"
                + "transactionSummary='"
                + transactionSummary
                + '\''
                + ", location='"
                + location
                + '\''
                + ", transactionBalance="
                + transactionBalance
                + ", transactionDate="
                + transactionDate
                + ", transactionTime="
                + transactionTime
                + ", memberList="
                + memberList
                + ", remainder="
                + remainder
                + '}';
    }
}
