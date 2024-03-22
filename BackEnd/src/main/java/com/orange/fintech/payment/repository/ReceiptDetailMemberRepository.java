package com.orange.fintech.payment.repository;

import com.orange.fintech.payment.entity.ReceiptDetail;
import com.orange.fintech.payment.entity.ReceiptDetailMember;
import com.orange.fintech.payment.entity.ReceiptDetailMemberPK;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReceiptDetailMemberRepository
        extends JpaRepository<ReceiptDetailMember, ReceiptDetailMemberPK> {

    List<ReceiptDetailMember> findByReceiptDetailMemberPKReceiptDetail(ReceiptDetail receiptDetail);
}
