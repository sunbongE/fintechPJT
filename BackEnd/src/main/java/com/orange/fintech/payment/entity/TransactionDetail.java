package com.orange.fintech.payment.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Getter
@Setter
public class TransactionDetail {

    @Id
    @OneToOne
    //    @JoinColumn(name = "transaction_detail_id")
    @JoinColumn(name = "transaction_id")
    private Transaction transaction;

    @Column(length = 20)
    private String memo;

    private int remainder;

    @ColumnDefault("false")
    private boolean receiptEnrolled;
}
