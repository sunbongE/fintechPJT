package com.orange.fintech.account.repository;

import com.orange.fintech.account.dto.LatestDateTimeDto;
import com.orange.fintech.account.dto.TransactionResDto;
import com.orange.fintech.account.entity.QAccount;
import com.orange.fintech.payment.entity.QTransaction;
import com.orange.fintech.payment.entity.Transaction;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static com.orange.fintech.payment.entity.QTransaction.*;
import static com.querydsl.jpa.JPAExpressions.select;

@Slf4j
@Repository
@RequiredArgsConstructor
@Transactional
public class AccountQueryRepository {

    private final JPAQueryFactory queryFactory;

    public List<Transaction> readAllOrUpdateTransation(String kakaoId){

        return queryFactory
                .select(
                        Projections.bean(
                                Transaction.class,
                                transaction.transactionId,
                                transaction.transactionUniqueNo,
                                transaction.transactionAccountNo,
                                transaction.transactionDate,
                                transaction.transactionTime,
                                transaction.transactionType,
                                transaction.transactionTypeName,
                                transaction.transactionBalance,
                                transaction.transactionAfterBalance,
                                transaction.transactionSummary
                        )
                )
                .from(transaction)
                .where(transaction.account.eq(
                        select(QAccount.account)
                                .from(QAccount.account)
                                .where(QAccount.account.member.kakaoId.eq(kakaoId), QAccount.account.isPrimaryAccount.isTrue())
                    )
                )
                .orderBy(transaction.transactionDate.desc(), transaction.transactionTime.desc())
                .fetch();


    }

    public LatestDateTimeDto getLatest(String kakaoId) {

        List<Transaction> result = queryFactory
                .select(
                        Projections.bean(
                                Transaction.class,
                                transaction.transactionDate,
                                transaction.transactionTime
                        )
                )
                .from(transaction)
                .where(transaction.account.eq(
                                select(QAccount.account)
                                        .from(QAccount.account)
                                        .where(QAccount.account.member.kakaoId.eq(kakaoId), QAccount.account.isPrimaryAccount.isTrue())
                        )
                )
                .orderBy(transaction.transactionDate.desc(), transaction.transactionTime.desc())
                .limit(1)
                .fetch();
        Transaction latestData = result.get(0);
        LatestDateTimeDto dto = new LatestDateTimeDto(latestData);

        return dto;
    }
}
