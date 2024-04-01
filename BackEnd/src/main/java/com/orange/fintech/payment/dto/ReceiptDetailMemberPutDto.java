package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "영수증 세부 인원, 금액 설정 Dto")
public class ReceiptDetailMemberPutDto {

    //    @Schema(description = "영수증 상세 id")
    //    int receiptDetailId;

    @Schema(description = "멤버 id")
    private String memberId;

    @Schema(description = "낼 금액")
    long amountDue;
}
