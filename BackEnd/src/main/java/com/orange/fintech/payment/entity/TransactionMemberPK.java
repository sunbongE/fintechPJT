package com.orange.fintech.payment.entity;

import com.orange.fintech.member.entity.Member;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.io.Serializable;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class TransactionMemberPK implements Serializable {

    @ManyToOne
    @JoinColumn(name = "transaction_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Transaction transaction;

    @ManyToOne
    @JoinColumn(name = "kakao_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Member member;
}
