package com.orange.fintech.payment.service;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.dto.TransactionDto;
import java.util.List;

public interface PaymentService {

    List<TransactionDto> getMyTransaction(Member member, Group group);

    boolean changeContainStatus(int transactionId, int groupId);
}
