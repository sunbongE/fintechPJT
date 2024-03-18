package com.orange.fintech.payment.entity;

import com.orange.fintech.group.entity.Group;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Getter
@Setter
@DynamicUpdate
public class TransactionDetail {

    @Id private int transaction_id;

    @MapsId
    @OneToOne
    @JoinColumn(name = "transaction_id")
    private Transaction transaction;

    @ManyToOne
    @JoinColumn(name = "group_id")
    private Group group;

    @Column(length = 20)
    private String memo;

    private int remainder;

    @ColumnDefault("false")
    private boolean receiptEnrolled;
}
