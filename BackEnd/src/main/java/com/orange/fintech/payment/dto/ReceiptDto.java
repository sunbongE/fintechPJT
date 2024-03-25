package com.orange.fintech.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.ReceiptDetail;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
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
@Schema(description = "영수증 Dto")
public class ReceiptDto {

    @Schema(description = "영수증 id")
    private int receiptId;

    @Schema(description = "상호")
    private String businessName;

    @Schema(description = "지점")
    private String subName;

    @Schema(description = "위치")
    private String location;

    @Schema(description = "거래일자")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @Schema(description = "거래시각")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    @Schema(description = "총 금액")
    private int totalPrice;

    @Schema(description = "승인 금액")
    private int approvalAmount;

    @Schema(description = "승인 번호")
    private long authNumber;

    @Schema(description = "지도 표시 여부")
    private Boolean visibility;

    @Schema(description = "영수증 항목 리스트")
    List<ReceiptDetailDto> detailList;

    public static ReceiptDto of(Receipt receipt) {
        ReceiptDto res = new ReceiptDto();
        res.setReceiptId(receipt.getReceiptId());
        res.setBusinessName(receipt.getBusinessName());
        res.setLocation(receipt.getLocation());
        res.setTransactionDate(receipt.getTransactionDate());
        res.setTransactionTime(receipt.getTransactionTime());
        res.setTotalPrice(receipt.getTotalPrice());
        res.setApprovalAmount(receipt.getApprovalAmount());
        res.setAuthNumber(receipt.getAuthNumber());
        res.setVisibility(receipt.getVisibility());
        return res;
    }

    public static ReceiptDto of(Receipt receipt, List<ReceiptDetail> list) {
        ReceiptDto res = of(receipt);

        List<ReceiptDetailDto> tmp = new ArrayList<>();
        for (ReceiptDetail detail : list) {
            tmp.add(ReceiptDetailDto.of(detail));
        }
        res.setDetailList(tmp);

        return res;
    }
}
