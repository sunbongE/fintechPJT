package com.orange.fintech.payment.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class ReceiptDetailMember {

    @EmbeddedId private ReceiptDetailMemberPK receiptDetailMemberPK;

    private Long amountDue;
}
