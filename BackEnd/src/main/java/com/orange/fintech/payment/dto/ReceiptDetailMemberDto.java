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
@Schema(description = "영수증 참여 멤버 Dto")
public class ReceiptDetailMemberDto {

    @Schema(description = "영수증 상세 id")
    int receiptDetailId;

    @Schema(description = "멤버 id")
    private String memberId;

    @Schema(description = "멤버 이름")
    String name;

    @Schema(description = "멤버 프로필 사진")
    String thumbnailImage;

    @Schema(description = "낼 금액")
    int amountDue;
}
