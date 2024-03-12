package com.orange.fintech.transaction.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicInsert;

@Entity
@Getter
@Setter
public class ReceiptDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int receiptDetailId;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "receipt_id")
    private Receipt receipt;

    @Column(length = 25)
    private String menu;

    private int count;

    private int unitPrice;

}
