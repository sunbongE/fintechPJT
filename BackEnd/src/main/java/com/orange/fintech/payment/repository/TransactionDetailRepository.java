package com.orange.fintech.payment.repository;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.payment.entity.TransactionDetail;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionDetailRepository extends JpaRepository<TransactionDetail, Integer> {

    List<TransactionDetail> findByGroup(Group group);
}
