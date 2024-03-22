package com.orange.fintech.payment.dto;

import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.entity.ReceiptDetail;
import com.orange.fintech.payment.entity.ReceiptDetailMember;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "영수증 항목 상세 Dto")
public class ReceiptDetailRes {

    @Schema(description = "영수증 id")
    private int receiptId;

    @Schema(description = "상품명")
    private String menu;

    @Schema(description = "개수")
    private int count;

    @Schema(description = "단가")
    private int unitPrice;

    @Schema(description = "참여 멤버 리스트")
    List<ReceiptDetailMemberDto> memberList;

    public static ReceiptDetailRes of(ReceiptDetail receiptDetail) {
        ReceiptDetailRes res = new ReceiptDetailRes();
        res.setReceiptId(receiptDetail.getReceiptDetailId());
        res.setMenu(receiptDetail.getMenu());
        res.setCount(receiptDetail.getCount());
        res.setUnitPrice(receiptDetail.getUnitPrice());

        return res;
    }

    public static ReceiptDetailRes of(
            ReceiptDetail receiptDetail, List<ReceiptDetailMember> memberList) {
        ReceiptDetailRes res = of(receiptDetail);

        List<ReceiptDetailMemberDto> tmp = new ArrayList<>();
        for (ReceiptDetailMember detailMember : memberList) {
            Member member = detailMember.getReceiptDetailMemberPK().getMember();
            tmp.add(
                    new ReceiptDetailMemberDto(
                            detailMember
                                    .getReceiptDetailMemberPK()
                                    .getReceiptDetail()
                                    .getReceiptDetailId(),
                            member.getKakaoId(),
                            member.getName(),
                            member.getThumbnailImage(),
                            detailMember.getAmountDue()));
        }

        return res;
    }
}
