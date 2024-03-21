package com.orange.fintech.payment.service;

import com.orange.fintech.payment.dto.TransactionDetailRes;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.TransactionMemberDto;
import com.orange.fintech.payment.dto.TransactionPostReq;
import java.util.List;
import java.util.NoSuchElementException;

public interface PaymentService {

    boolean addTransaction(String memberId, int groupId, TransactionPostReq addTransactionDto);

    void addTransactionMember(int transactionId, TransactionMemberDto dto);

    List<TransactionDto> getMyTransaction(String memberId, int groupId, int page, int pageSize);

    boolean isMyTransaction(String memberId, int transactionId);

    boolean changeContainStatus(int transactionId, int groupId);

    void memo(int transactionId, String memo) throws NoSuchElementException;

    TransactionDetailRes getTransactionDetail(int transactionId);

    List<TransactionDto> getGroupTransaction(
            String memgerId, int groupId, int page, int pageSize, String option);
}
