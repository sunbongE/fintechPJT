package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "여정 요청한 내역 Request Dto")
public class YeojungDetailReq {

    @Schema(description = "다른 멤버 id")
    String otherMemberId;

    @Schema(description = "요정 타입", example = "SEND(보낼 금액) || RECEIVE(받을 금액)")
    String type;
}
