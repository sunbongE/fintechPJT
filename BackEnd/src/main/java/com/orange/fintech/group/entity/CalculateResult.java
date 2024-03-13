package com.orange.fintech.group.entity;

import com.orange.fintech.member.entity.Member;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class CalculateResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int calculateResultId;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "group_id")
    private Group group;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "send_member_id")
    private Member sendMember;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "receive_member_id")
    private Member receiveMember;

    @NotNull private long amount;
}
