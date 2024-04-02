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
import com.orange.fintech.payment.entity.TransactionMember;
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

    OrderSpecifier<String> dateOrderSpecifier =
            Expressions.stringPath("transaction.transactionDate").desc();
    OrderSpecifier<String> timeOrderSpecifier =
            Expressions.stringPath("transaction.transactionTime").desc();
    @Autowired private JPAQueryFactory jpaQueryFactory;

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
                                        transactionDetail.memo, //
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

    public List<TransactionMember> getTransactionMember(int transactionId) {
        return jpaQueryFactory
                .select(transactionMember)
                .from(transactionMember)
                .where(
                        transactionMember
                                .totalAmount
                                .gt(0)
                                .and(
                                        transactionMember.transactionMemberPK.transaction
                                                .transactionId.eq(transactionId)))
                .fetch();
    }

    public List<TransactionDto> getGroupTransaction(
            Group group, int page, int pageSize, String condition, Member member) {

        log.info("queryRepository getGroupTransaction start");

        BooleanExpression expression;
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

    /**
     * @param memberId
     * @param receiptId
     * @return
     */
    public long getTransactionTotalAmount(String memberId, int receiptId) {
        long res = 0;
        try {
            res =
                    jpaQueryFactory
                            .select(receiptDetailMember.amountDue.sum())
                            .from(receipt)
                            .join(receiptDetail)
                            .on(receipt.eq(receiptDetail.receipt))
                            .join(receiptDetailMember)
                            .on(
                                    receiptDetail.eq(
                                            receiptDetailMember
                                                    .receiptDetailMemberPK
                                                    .receiptDetail))
                            .where(
                                    receiptDetailMember
                                            .receiptDetailMemberPK
                                            .member
                                            .kakaoId
                                            .eq(memberId)
                                            .and(receipt.receiptId.eq(receiptId)))
                            .fetchOne();
        } catch (NullPointerException e) {
            log.info("[ERROR] {}", e.getMessage());
        }

        log.info("getTransactionTotalAmount({}, {}): {}", memberId, receiptId, res);
        return res;
    }

    /**
     * @param condition 조건 (SEND-보내야할 금액, RECEIVE-줘야할 금액)
     * @return
     */
    public BooleanExpression getSumOfTotalAmountCondition(
            int groupId, String memberId, String condition) {
        BooleanExpression expression;
        if (condition.equals("SEND")) {
            expression =
                    transactionDetail
                            .group
                            .groupId
                            .eq(groupId)
                            .and(transactionMember.transactionMemberPK.member.kakaoId.eq(memberId))
                            .and(transaction.member.kakaoId.ne(memberId));
        } else { // "RECEIVE"
            expression =
                    transactionDetail
                            .group
                            .groupId
                            .eq(groupId)
                            .and(transactionMember.transactionMemberPK.member.kakaoId.ne(memberId))
                            .and(transaction.member.kakaoId.eq(memberId));
        }

        return expression;
    }

    /**
     * @param groupId 계산할 그룹 아이디
     * @param memberId 내 아이디
     * @param expression 조건 (SEND-보내야할 금액, RECEIVE-줘야할 금액)
     * @return
     */
    public long sumOfTotalAmount(int groupId, String memberId, BooleanExpression expression) {
        long res = 0L;
        try {
            res =
                    jpaQueryFactory
                            .select(transactionMember.totalAmount.sum())
                            .from(transaction)
                            .join(transactionMember)
                            .on(transaction.eq(transactionMember.transactionMemberPK.transaction))
                            .join(transactionDetail)
                            .on(transactionDetail.transaction.eq(transaction))
                            .where(expression)
                            .fetchOne();
        } catch (NullPointerException e) {
            log.info("계산될 금액 없음");
        }

        return res;
    }

    public int sumOfMyRemainder(int groupId, String memberId) {
        int res = 0;
        try {
            res =
                    jpaQueryFactory
                            .select(transactionDetail.remainder.sum())
                            .from(transaction)
                            .join(transactionDetail)
                            .on(transaction.eq(transactionDetail.transaction))
                            .where(
                                    transactionDetail
                                            .group
                                            .groupId
                                            .eq(groupId)
                                            .and(transaction.member.kakaoId.eq(memberId)))
                            .fetchOne();
        } catch (NullPointerException e) {
            log.info("{}가 받을 나머지 없음", memberId);
        }

        return res;
    }

    public int sumOfRemainder(int groupId) {
        int res = 0;
        try {
            res =
                    jpaQueryFactory
                            .select(transactionDetail.remainder.sum())
                            .from(transactionDetail)
                            //                        .join(transactionDetail)
                            //
                            // .on(transaction.eq(transactionDetail.transaction))
                            .where(transactionDetail.group.groupId.eq(groupId))
                            .fetchOne();
        } catch (NullPointerException e) {
            log.info("계산될 나머지 없음");
        }

        log.info("groupId:{} -> sumOfRemainder: {}", groupId, res);
        return res;
    }

    /**
     * 내가 otherId에게 받아야할 금액 구하기
     *
     * @param myId 내 아이디
     * @param otherId 다른 사람의 아이디
     * @return 받아야할 금액
     */
    public long getReceiveAmount(String myId, String otherId) {
        long res = 0;
        try {
            res =
                    jpaQueryFactory
                            .select(transactionMember.totalAmount.sum())
                            .from(transaction)
                            .join(transactionMember)
                            .on(transaction.eq(transactionMember.transactionMemberPK.transaction))
                            .where(
                                    transactionMember
                                            .transactionMemberPK
                                            .member
                                            .kakaoId
                                            .eq(otherId)
                                            .and(transaction.member.kakaoId.eq(myId)))
                            .fetchOne();

        } catch (NullPointerException e) {
            log.info("받을 금액 계산 불가");
        }

        return res;
    }

    /**
     * 다른 사람의 transaction의 멤버로 내가 포함되어있는지
     *
     * @param groupId 그룹 아이디
     * @param memberId 내 아이디
     * @param otherMemberId 다른 사람 아이디
     * @return 내가 다른 사람에게 받은 요청
     */
    public List<TransactionDto> getReceivedRequest(
            int groupId, String memberId, String otherMemberId) {
        List<TransactionDto> res =
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
                        .from(transaction)
                        .join(transactionDetail)
                        .on(transaction.eq(transactionDetail.transaction))
                        .join(transactionMember)
                        .on(transaction.eq(transactionMember.transactionMemberPK.transaction))
                        .where(
                                transaction
                                        .member
                                        .kakaoId
                                        .eq(otherMemberId)
                                        .and(transactionDetail.group.groupId.eq(groupId))
                                        .and(
                                                transactionMember.transactionMemberPK.member.kakaoId
                                                        .eq(memberId)))
                        .fetch();

        return res;
    }

    /**
     * @param transactionId
     * @return transaction에 참여하는 member 수
     */
    public int countTransactionMember(int transactionId) {
        return jpaQueryFactory
                .select(transactionMember)
                .from(transactionMember)
                .where(
                        transactionMember
                                .transactionMemberPK
                                .transaction
                                .transactionId
                                .eq(transactionId)
                                .and(transactionMember.totalAmount.gt(0)))
                .fetch()
                .size();
    }

    /**
     * @param transactionId 영수증 id
     * @return 영수증의 모든 세부 항목에 참여하는 사람
     */
    public int countReceiptDetailMember(int transactionId) {
        return jpaQueryFactory
                .select(receiptDetailMember)
                .from(receiptDetail)
                .join(receiptDetailMember)
                .on(receiptDetail.eq(receiptDetailMember.receiptDetailMemberPK.receiptDetail))
                .where(
                        receiptDetail
                                .receipt
                                .transaction
                                .transactionId
                                .eq(transactionId)
                                .and(receiptDetailMember.amountDue.gt(0)))
                .fetch()
                .size();
    }

    public int countReceiptDetail(int transactionId) {
        return jpaQueryFactory
                .select(receiptDetail)
                .from(receiptDetail)
                .where(receiptDetail.receipt.transaction.transactionId.eq(transactionId))
                .fetch()
                .size();
    }

    public int countIsLockTransactionMember(int transactionId) {
        return jpaQueryFactory
                .select(transactionMember)
                .from(transactionMember)
                .join(transaction)
                .on(transaction.eq(transactionMember.transactionMemberPK.transaction))
                .where(transaction.transactionId.eq(transactionId).and(transactionMember.isLock))
                .fetch()
                .size();
    }
}
