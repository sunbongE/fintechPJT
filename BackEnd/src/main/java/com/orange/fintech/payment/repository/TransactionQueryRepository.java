package com.orange.fintech.payment.repository;

import static com.orange.fintech.payment.entity.QReceipt.receipt;
import static com.orange.fintech.payment.entity.QReceiptDetail.receiptDetail;
import static com.orange.fintech.payment.entity.QReceiptDetailMember.receiptDetailMember;
import static com.orange.fintech.payment.entity.QTransaction.transaction;
import static com.orange.fintech.payment.entity.QTransactionDetail.transactionDetail;
import static com.orange.fintech.payment.entity.QTransactionMember.transactionMember;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.payment.dto.TransactionDetailRes;
import com.orange.fintech.payment.dto.TransactionDto;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
public class TransactionQueryRepository {

    @Autowired private JPAQueryFactory jpaQueryFactory;

    OrderSpecifier<String> dateOrderSpecifier =
            Expressions.stringPath("transaction.transactionDate").desc();
    OrderSpecifier<String> timeOrderSpecifier =
            Expressions.stringPath("transaction.transactionTime").desc();

    public List<TransactionDto> getMyTransactionByMemberAndGroup(
            Member member, Group group, int page, int pageSize) {

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
                                                        .ne("1")
                                                        .or(transaction.transactionType.isNull())))
                        .orderBy(dateOrderSpecifier, timeOrderSpecifier)
                        .offset(pageSize * page)
                        .limit(pageSize)
                        .fetch();

        log.info("pageSize: {}", pageSize);
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

    public List<TransactionDto> getGroupTransaction(
            Group group, int page, int pageSize, String condition, Member member) {

        log.info("queryRepository getGroupTransaction start");

        BooleanExpression expression = null;
        if ("my".equals(condition)) {
            expression =
                    transactionMember
                            .transactionMemberPK
                            .member
                            .eq(member)
                            .and(transactionMember.totalAmount.gt(0))
                            .and(transactionDetail.group.eq(group));
        } else {
            expression = transactionDetail.group.eq(group);
        }

        JPAQuery<TransactionDto> from =
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
                                        transactionDetail.receiptEnrolled))
                        .from(transactionDetail);

        List<TransactionDto> res =
                joinIfMyOption(from, condition)
                        .join(transaction)
                        .on(transactionDetail.transaction.eq(transaction))
                        .where(expression)
                        .orderBy(dateOrderSpecifier, timeOrderSpecifier)
                        .offset(pageSize * page)
                        .limit(pageSize)
                        .fetch();

        log.info("getGroupTransaction: {}", res);
        log.info("size: {}", res.size());

        return res;
    }

    private <T> JPAQuery<T> joinIfMyOption(JPAQuery<T> selectQuery, String option) {
        return "my".equals(option)
                ? selectQuery
                        .innerJoin(transactionMember)
                        .on(
                                transactionMember.transactionMemberPK.transaction.eq(
                                        transactionDetail.transaction))
                : selectQuery;
    }

    public int getTransactionTotalAmount(String memberId, int receiptId) {
        int res =
                jpaQueryFactory
                        .select(receiptDetailMember.amountDue.sum())
                        .from(receipt)
                        .join(receiptDetail)
                        .on(receipt.eq(receiptDetail.receipt))
                        .join(receiptDetailMember)
                        .on(
                                receiptDetail.eq(
                                        receiptDetailMember.receiptDetailMemberPK.receiptDetail))
                        .where(
                                receiptDetailMember
                                        .receiptDetailMemberPK
                                        .member
                                        .kakaoId
                                        .eq(memberId)
                                        .and(receipt.receiptId.eq(receiptId)))
                        .fetchOne();

        log.info("getTransactionTotalAmount({}, {}): {}", memberId, receiptId, res);
        return res;
    }

    public long sumOfTotalAmount(int groupId, String memberId) {
        long res =
                jpaQueryFactory
                        .select(transactionMember.totalAmount.sum())
                        .from(transaction)
                        .join(transactionMember)
                        .on(transaction.eq(transactionMember.transactionMemberPK.transaction))
                        .join(transactionDetail)
                        .on(transactionDetail.transaction.eq(transaction))
                        .where(
                                transactionDetail
                                        .group
                                        .groupId
                                        .eq(groupId)
                                        .and(
                                                transactionMember.transactionMemberPK.member.kakaoId
                                                        .eq(memberId)))
                        .fetchOne();

        log.info("sumOfTotalAmount: {}", res);
        return res;
    }

    public int sumOfRemainder(int groupId) {
        int res =
                jpaQueryFactory
                        .select(transactionDetail.remainder.sum())
                        .from(transaction)
                        .join(transactionDetail)
                        .on(transaction.eq(transactionDetail.transaction))
                        .where(transactionDetail.group.groupId.eq(groupId))
                        .fetchOne();

        log.info("groupId:{} -> sumOfRemainder: {}", groupId, res);
        return res;
    }
}
