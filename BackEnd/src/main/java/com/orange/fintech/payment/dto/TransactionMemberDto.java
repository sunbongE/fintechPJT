package com.orange.fintech.payment.dto;

import com.orange.fintech.payment.entity.TransactionMember;
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

    @Schema(description = "금액 고정 여부")
    private boolean isLock;

    public static TransactionMemberDto of(TransactionMember tm) {
        TransactionMemberDto res = new TransactionMemberDto();
        res.setMemberId(tm.getTransactionMemberPK().getMember().getKakaoId());
        res.setLock(tm.getIsLock());
        res.setTotalAmount(tm.getTotalAmount());
        return res;
    }
}
