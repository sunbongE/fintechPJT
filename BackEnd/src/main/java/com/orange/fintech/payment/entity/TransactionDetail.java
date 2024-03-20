package com.orange.fintech.payment.entity;

import com.orange.fintech.group.entity.Group;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Setter
@ToString
@DynamicUpdate
public class TransactionDetail {

    @Id private Integer transactionId;

    @MapsId("transactionId")
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transaction_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Transaction transaction;

    @ManyToOne
    @JoinColumn(name = "group_id")
    private Group group;

    @Column(length = 20)
    private String memo;

    private Integer remainder;

    @ColumnDefault("false")
    private boolean receiptEnrolled;
}
