package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "최종정산 계산 결과 Dto")
public class CalculateResultDto {

    @Schema(description = "송금하는 멤버 id")
    private String sendMemberId;

    @Schema(description = "입금받는 멤버 id")
    private String receiveMemberId;

    @Schema(description = "금액")
    private Long amount;
}
