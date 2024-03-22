package com.orange.fintech.payment.dto;

import com.orange.fintech.payment.entity.ReceiptDetail;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "영수증 항목 Dto")
public class ReceiptDetailDto {

    @Schema(description = "영수증 상세내역 id")
    private int receiptDetailId;

    @Schema(description = "상품명")
    private String menu;

    @Schema(description = "개수")
    private int count;

    @Schema(description = "단가")
    private int unitPrice;

    public static ReceiptDetailDto of(ReceiptDetail receiptDetail) {
        ReceiptDetailDto res = new ReceiptDetailDto();
        res.setReceiptDetailId(receiptDetail.getReceiptDetailId());
        res.setMenu(receiptDetail.getMenu());
        res.setCount(receiptDetail.getCount());
        res.setUnitPrice(receiptDetail.getUnitPrice());
        return res;
    }
}
