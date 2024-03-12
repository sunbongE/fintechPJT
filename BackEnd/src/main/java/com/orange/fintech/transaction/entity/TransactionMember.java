package com.orange.fintech.transaction.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class TransactionMember {

    @EmbeddedId
    private TransactionMemberPK transactionMemberPK;

    private int totalAmount;

}
