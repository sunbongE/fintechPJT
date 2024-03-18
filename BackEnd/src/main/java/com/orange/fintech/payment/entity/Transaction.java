package com.orange.fintech.payment.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalTime;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
// @DynamicInsert
// @DynamicUpdate
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int transactionId;

    //    @ManyToOne
    //    @JoinColumn(name = "group_id")
    //    private Group group;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "account_id")
    private Account account;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "kakao_id")
    private Member member;

    //    @Column(nullable = true)
    private Integer transactionUniqueNo;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    private LocalDate transactionDate;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HHmmss", timezone = "Asia/Seoul")
    private LocalTime transactionTime;

    @Column(length = 5)
    private String transactionType;

    @Column(length = 10)
    private String transactionTypeName;

    private Long transactionBalance;

    private Long transactionAfterBalance;

    @NotNull
    @Column(length = 20)
    private String transactionSummary;
}
