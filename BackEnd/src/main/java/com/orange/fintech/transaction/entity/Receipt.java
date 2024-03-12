package com.orange.fintech.transaction.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Null;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@DynamicInsert
//@DynamicUpdate
public class Receipt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int receiptId;

    @OneToOne
    @JoinColumn(name = "transaction_id")
    private Transaction transaction;

    @NotNull
    private String businessName;

    @NotNull
    private String location;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd HHmmss", timezone = "Asia/Seoul")
    private LocalDateTime dateTime;

    @NotNull
    private int totalPrice;

    @NotNull
    private int approvalAmount;

    private long authNumber;

    private double latitude;

    private double longitude;

    @NotNull
    @ColumnDefault("true")
    private Boolean visibility;

}
