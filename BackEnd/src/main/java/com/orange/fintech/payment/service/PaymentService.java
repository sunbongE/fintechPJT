package com.orange.fintech.payment.service;

import com.orange.fintech.payment.dto.TransactionDto;
import java.util.List;
import java.util.NoSuchElementException;

public interface PaymentService {

    List<TransactionDto> getMyTransaction(String memberId, int groupId);

    boolean isMyTransaction(String memberId, int transactionId);

    boolean changeContainStatus(int transactionId, int groupId);

    void memo(int transactionId, String memo) throws NoSuchElementException;
}
