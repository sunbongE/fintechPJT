package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "여정 Dto")
public class YeojungDto {

    @Schema(description = "유저 id")
    String memberId;

    @Schema(description = "유저 이름")
    String name;

    @Schema(description = "받을 금액")
    Long receiveAmount;

    @Schema(description = "보낼 금액")
    Long sendAmount;
}
