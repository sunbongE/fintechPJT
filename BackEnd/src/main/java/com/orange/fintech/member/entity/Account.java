package com.orange.fintech.member.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Getter
@Setter
public class Account {

    @Id
    @Column(length = 20)
    private String accountNo;

    @ManyToOne
    @JoinColumn(name = "kakao_id")
    private Member member;

    @NotNull private Long balance;

    @ColumnDefault("false")
    private Boolean isPrimaryAccount;

    @NotNull private String institutionCode;
}
