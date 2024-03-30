package com.orange.fintech.account.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.entity.Transaction;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Setter
@DynamicInsert
public class Account {

    @Id
    @Column(length = 20)
    private String accountNo;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "kakao_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Member member;

    @NotNull private Long balance;

    @NotNull
    @ColumnDefault("true")
    private Boolean isPrimaryAccount;

    @NotNull private String bankCode;

    @OneToMany(mappedBy = "account")
    private List<Transaction> transactionList;

    public Account() {
        this.isPrimaryAccount = true;
    }

    @Override
    public String toString() {
        return "Account{"
                + "accountNo='"
                + accountNo
                + '\''
                + ", balance="
                + balance
                + ", isPrimaryAccount="
                + isPrimaryAccount
                + ", bankCode='"
                + bankCode
                + '\''
                + '}';
    }
}
