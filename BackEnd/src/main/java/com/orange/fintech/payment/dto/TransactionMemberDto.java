package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "거래 멤버 Dto")
public class TransactionMemberDto {

    @Schema(description = "멤버 id")
    private String memberId;

    @Schema(description = "낼 금액")
    private Integer totalAmount;

    // SINYEONG
    @Schema(description = "금액 고정 여부")
    private boolean isLock;
}
