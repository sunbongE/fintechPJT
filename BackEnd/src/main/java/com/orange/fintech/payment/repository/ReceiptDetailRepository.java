package com.orange.fintech.payment.repository;

import com.orange.fintech.payment.entity.Receipt;
import com.orange.fintech.payment.entity.ReceiptDetail;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReceiptDetailRepository extends JpaRepository<ReceiptDetail, Integer> {

    List<ReceiptDetail> findByReceipt(Receipt receipt);

    @Modifying
    @Query("DELETE FROM ReceiptDetail rd WHERE rd.receipt = :receipt")
    void deleteRecordsByReceipt(@Param("receipt") Receipt receipt);
}
