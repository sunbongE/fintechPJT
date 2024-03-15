package com.orange.fintech.payment.entity;

import com.orange.fintech.member.entity.Member;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.io.Serializable;
import lombok.*;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ReceiptDetailMemberPK implements Serializable {

    @ManyToOne
    @JoinColumn(name = "receipt_detail_id")
    private ReceiptDetail receiptDetail;

    @ManyToOne
    @JoinColumn(name = "kakao_id")
    private Member member;
}
