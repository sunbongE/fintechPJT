package com.orange.fintech.transaction.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalTime;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Getter
@Setter
@DynamicInsert
@DynamicUpdate
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int transactionId;

    @ManyToOne
    @JoinColumn(name = "group_id")
    private Group group;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "account_id")
    private Account account;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @NotNull private int transactionUniqueNo;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    @NotNull
    @Column(length = 5)
    private String transactionType;

    @NotNull
    @Column(length = 10)
    private String transactionTypeName;

    @NotNull private long transactionBalance;

    @NotNull private long transactionAfterBalance;

    @NotNull
    @Column(length = 20)
    private String transactionSummary;

    @Column(length = 20)
    private String memo;

    private int remainder;

    @ColumnDefault("false")
    private boolean receiptEnrolled;
}
