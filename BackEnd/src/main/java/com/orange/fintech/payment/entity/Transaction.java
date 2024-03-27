package com.orange.fintech.payment.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.util.AccountDateTimeUtil;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.json.simple.JSONObject;

@Entity
@Getter
@Setter
@ToString
@DynamicInsert
// @DynamicUpdate
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int transactionId;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private Account account;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "kakao_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Member member;

    private Integer transactionUniqueNo;

    private String transactionAccountNo; // 거래한 계좌번호.

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

    @OneToOne(cascade = CascadeType.ALL,fetch = FetchType.LAZY)
    private TransactionDetail transactionDetail;

    public Transaction() {}

    public Transaction(JSONObject data, Account curAccount, Member member) {
        this.account = curAccount;
        this.member = member;
        this.transactionType = data.get("transactionType").toString();
        this.transactionAfterBalance =
                Long.parseLong(data.get("transactionAfterBalance").toString());
        this.transactionUniqueNo = Integer.parseInt(data.get("transactionUniqueNo").toString());
        this.transactionBalance = Long.parseLong(data.get("transactionBalance").toString());
        this.transactionSummary = data.get("transactionSummary").toString();
        this.transactionDate = AccountDateTimeUtil.StringToLocalDate(data.get("transactionDate").toString());
        this.transactionTime = AccountDateTimeUtil.StringToLocalTime(data.get("transactionTime").toString());
        this.transactionTypeName = data.get("transactionTypeName").toString();
    }

//    private LocalDate StringToLocalDate(String stringDate) {
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
//        LocalDate date = LocalDate.parse(stringDate, formatter);
//        return date;
//    }
//
//    private LocalTime StringToLocalTime(String stringTime) {
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmmss");
//        LocalTime date = LocalTime.parse(stringTime, formatter);
//        return date;
//    }
}
