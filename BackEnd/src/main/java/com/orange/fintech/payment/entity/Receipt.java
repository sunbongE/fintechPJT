package com.orange.fintech.payment.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.*;

@Entity
@Getter
@Setter
@DynamicInsert
@DynamicUpdate
public class Receipt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int receiptId;

    @OneToOne
    @JoinColumn(name = "transaction_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Transaction transaction;

    @NotNull private String businessName;

    @NotNull private String location;

    @NotNull
    @JsonFormat(
            shape = JsonFormat.Shape.STRING,
            pattern = "yyyy-MM-dd HH:mm:ss",
            timezone = "Asia/Seoul")
    private LocalDateTime dateTime;

    @NotNull private int totalPrice;

    @NotNull private int approvalAmount;

    private long authNumber;

    //    private double latitude;

    //    private double longitude;

    @NotNull
    @ColumnDefault("true")
    private Boolean visibility;
}
