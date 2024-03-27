package com.orange.fintech.payment.dto;

import com.orange.fintech.member.entity.Member;
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

    @Schema(description = "멤버 이름")
    String name;

    @Schema(description = "멤버 프로필 사진")
    String thumbnailImage;

    @Schema(description = "낼 금액")
    private Long totalAmount;

    @Schema(description = "금액 고정 여부")
    private boolean isLock;

    public static TransactionMemberDto of(TransactionMember transactionMember) {
        TransactionMemberDto res = new TransactionMemberDto();
        Member member = transactionMember.getTransactionMemberPK().getMember();
        res.setMemberId(member.getKakaoId());
        res.setName(member.getName());
        res.setThumbnailImage(member.getThumbnailImage());
        res.setLock(transactionMember.getIsLock());
        res.setTotalAmount(transactionMember.getTotalAmount());
        return res;
    }
}
