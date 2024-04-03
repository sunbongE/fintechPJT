package com.orange.fintech.group.entity;

import com.orange.fintech.member.entity.Member;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class CalculateResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int calculateResultId;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    private Group group;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "send_kakao_id")
    private Member sendMember;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receive_kakao_id")
    private Member receiveMember;

    @NotNull private long amount;
}
