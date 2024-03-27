package com.orange.fintech.payment.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class TransactionMember {

    @EmbeddedId private TransactionMemberPK transactionMemberPK;

    @NotNull private Long totalAmount;

    @NotNull private Boolean isLock;
}
