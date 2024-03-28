package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.*;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Schema(description = "<strong>CLOVA OCR</strong> 영수증 Dto")
public class ReceiptRequestDto {
    @Schema(description = "상호")
    private String businessName;

    @Schema(description = "지점")
    private String subName;

    @Schema(description = "위치")
    private String location;

    @Schema(description = "거래일시 (거래일자 + 거래시각)")
    private String date;

    @Schema(description = "영수증 항목 리스트")
    private List<Item> items;

    @Schema(description = "합계 금액")
    private int totalPrice;

    @Schema(description = "승인 금액")
    private int approvalAmount;

    @Getter
    @Setter
    @ToString
    @RequiredArgsConstructor
    public static class Item {
        @Schema(description = "메뉴명")
        private String name;

        @Schema(description = "수량")
        private int count;

        @Schema(description = "금액")
        private int price;
    }
}
