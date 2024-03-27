package com.orange.fintech.payment.service;

import com.orange.fintech.payment.dto.*;
import java.util.List;
import java.util.NoSuchElementException;

public interface PaymentService {

    boolean addTransaction(String memberId, int groupId, AddCashTransactionReq addTransactionDto);

    void addTransactionMember(int transactionId, TransactionMemberDto dto);

    List<TransactionDto> getMyTransaction(String memberId, int groupId, int page, int pageSize);

    boolean isMyTransaction(String memberId, int transactionId);

    boolean isMyGroup(String memberId, int groupId);

    boolean isMyGroupTransaction(int groupId, int transactionId);

    boolean changeContainStatus(int transactionId, int groupId);

    void editTransactionDetail(int transactionId, TransactionEditReq req)
            throws NoSuchElementException;

    TransactionDetailRes getTransactionDetail(int transactionId);

    List<TransactionDto> getGroupTransaction(
            String memberId, int groupId, int page, int pageSize, String option);

    GroupTransactionDetailRes getGroupTransactionDetail(int transactionId);

    ReceiptDto getGroupReceipt(int receiptId);

    ReceiptDetailRes getGroupReceiptDetail(int receiptDetailId);

    void setReceiptDetailMember(
            int paymentId, int receiptDetailId, List<ReceiptDetailMemberPutDto> req) throws Exception;
}
