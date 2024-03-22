package com.orange.fintech.payment.dto;

import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.TransactionMember;
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
@Schema(description = "그룹 거래 내역 상세 Dto")
public class GroupTransactionDetailRes {

    @Schema(description = "영수증")
    ReceiptDto receipt;

    @Schema(description = "거래 멤버 리스트")
    private List<TransactionMemberDto> memberList;

    public static GroupTransactionDetailRes of(Receipt receipt) {
        GroupTransactionDetailRes res = new GroupTransactionDetailRes();
        res.setReceipt(ReceiptDto.of(receipt));
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
}
