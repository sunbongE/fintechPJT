package com.orange.fintech.payment.repository;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.entity.QTransaction;
import com.orange.fintech.payment.entity.QTransactionDetail;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
public class TransactionRepositorySupport {

    @Autowired private JPAQueryFactory jpaQueryFactory;

    QTransaction qTransaction = QTransaction.transaction;
    QTransactionDetail qTransactionDetail = QTransactionDetail.transactionDetail;

    public List<TransactionDto> getTransactionByMemberAndGroup(Member member, Group group) {
        List<TransactionDto> list =
                jpaQueryFactory
                        .select(
                                Projections.bean(
                                        TransactionDto.class,
                                        qTransaction.transactionId,
                                        qTransaction.transactionDate,
                                        qTransaction.transactionTime,
                                        qTransaction.transactionTypeName,
                                        qTransaction.transactionBalance,
                                        qTransaction.transactionAfterBalance,
                                        qTransaction.transactionSummary,
                                        qTransactionDetail.group.groupId,
                                        qTransactionDetail.memo,
                                        qTransactionDetail.receiptEnrolled))
                        .from(qTransaction)
                        .leftJoin(qTransactionDetail)
                        .on(qTransaction.transactionId.eq(qTransactionDetail.transactionId))
                        .where(
                                qTransaction
                                        .member
                                        .eq(member)
                                        .and(
                                                qTransactionDetail
                                                        .group
                                                        .eq(group)
                                                        .or(qTransactionDetail.group.isNull())))
                        .fetch();

        log.info("Member {}", member);
        log.info("Group {}", group);
        log.info("List {}", list.toArray());

        return list;
    }
}
