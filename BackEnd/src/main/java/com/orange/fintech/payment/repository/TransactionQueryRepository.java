package com.orange.fintech.payment.repository;

import static com.orange.fintech.payment.entity.QTransaction.transaction;
import static com.orange.fintech.payment.entity.QTransactionDetail.transactionDetail;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.dto.TransactionDetailRes;
import com.orange.fintech.payment.dto.TransactionDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
public class TransactionQueryRepository {

    @Autowired private JPAQueryFactory jpaQueryFactory;

    public List<TransactionDto> getTransactionByMemberAndGroup(Member member, Group group) {
        List<TransactionDto> list =
                jpaQueryFactory
                        .select(
                                Projections.bean(
                                        TransactionDto.class,
                                        transaction.transactionId,
                                        transaction.transactionDate,
                                        transaction.transactionTime,
                                        transaction.transactionType,
                                        transaction.transactionTypeName,
                                        transaction.transactionBalance,
                                        transaction.transactionAfterBalance,
                                        transaction.transactionSummary,
                                        transactionDetail.group.groupId,
                                        //
                                        // transactionDetail.memo,
                                        transactionDetail.receiptEnrolled))
                        .from(transaction)
                        .leftJoin(transactionDetail)
                        .on(transaction.transactionId.eq(transactionDetail.transactionId))
                        .where(
                                transaction
                                        .member
                                        .eq(member)
                                        .and(
                                                transactionDetail
                                                        .group
                                                        .eq(group)
                                                        .or(transactionDetail.group.isNull()))
                                        .and(
                                                transaction
                                                        .transactionType
                                                        .eq("2")
                                                        .or(transaction.transactionType.isNull())))
                        .fetch();

        log.info("Member {}", member);
        log.info("Group {}", group);
        log.info("List {}", list.toArray());

        return list;
    }

    public TransactionDetailRes getTransactionDetail(int transactionId) {
        TransactionDetailRes res =
                jpaQueryFactory
                        .select(
                                Projections.bean(
                                        TransactionDetailRes.class,
                                        transaction.transactionDate,
                                        transaction.transactionTime,
                                        transaction.transactionBalance,
                                        transaction.transactionSummary,
                                        transactionDetail.memo,
                                        transactionDetail.remainder,
                                        transactionDetail.receiptEnrolled))
                        .from(transaction)
                        .leftJoin(transactionDetail)
                        .on(transaction.eq(transactionDetail.transaction))
                        .where(transaction.transactionId.eq(transactionId))
                        .fetchOne();

        return res;
    }
}
