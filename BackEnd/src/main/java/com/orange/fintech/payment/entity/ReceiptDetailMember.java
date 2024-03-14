package com.orange.fintech.payment.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class ReceiptDetailMember {

    @EmbeddedId private ReceiptDetailMemberPK receiptDetailMemberPK;

    private int amountDue;
}
