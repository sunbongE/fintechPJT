package com.orange.fintech.payment.service;

import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.TransactionMemberDto;
import com.orange.fintech.payment.dto.TransactionPostReq;
import java.util.List;
import java.util.NoSuchElementException;

public interface PaymentService {

    boolean addTransaction(int groupId, TransactionPostReq addTransactionDto);

    List<TransactionDto> getMyTransaction(String memberId, int groupId);

    boolean isMyTransaction(String memberId, int transactionId);

    boolean changeContainStatus(int transactionId, int groupId);

    void memo(int transactionId, String memo) throws NoSuchElementException;

    void addTransactionMember(int transactionId, TransactionMemberDto dto);
}
