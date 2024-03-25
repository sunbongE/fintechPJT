package com.orange.fintech.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.TransactionDetail;
import com.orange.fintech.payment.entity.TransactionMember;
import io.swagger.v3.oas.annotations.media.Schema;
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
@Schema(description = "그룹 거래 내역 상세 Dto")
public class GroupTransactionDetailRes {

    @Schema(description = "영수증 id")
    private int receiptId;

    @Schema(description = "상호")
    private String businessName;

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

    @Schema(description = "메모")
    private String memo;

    @Schema(description = "자투리 금액")
    private Integer remainder;

    @Schema(description = "영수증 등록 여부")
    private Boolean receiptEnrolled;

    @Schema(description = "거래 멤버 리스트")
    private List<TransactionMemberDto> memberList;

    public static GroupTransactionDetailRes of(Receipt receipt) {
        GroupTransactionDetailRes res = new GroupTransactionDetailRes();
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

    public static GroupTransactionDetailRes of(
            Receipt receipt, List<TransactionMember> transactionMembers) {
        List<TransactionMemberDto> list = new ArrayList<>();
        for (TransactionMember transactionMember : transactionMembers) {
            list.add(TransactionMemberDto.of(transactionMember));
        }

        GroupTransactionDetailRes res = of(receipt);
        res.setMemberList(list);
        return res;
    }

    public static GroupTransactionDetailRes of(
            Receipt receipt,
            List<TransactionMember> transactionMembers,
            TransactionDetail transactionDetail) {
        GroupTransactionDetailRes res = of(receipt, transactionMembers);
        res.setMemo(transactionDetail.getMemo());
        res.setRemainder(transactionDetail.getRemainder());
        res.setReceiptEnrolled(transactionDetail.getReceiptEnrolled());
        return res;
    }
}
