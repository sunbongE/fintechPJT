package com.orange.fintech.map.repository;

import static com.orange.fintech.payment.entity.QReceipt.receipt;
import static com.orange.fintech.payment.entity.QTransactionDetail.transactionDetail;

import com.orange.fintech.map.dto.LocationDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
public class LocationQueryRepository {

    @Autowired private JPAQueryFactory jpaQueryFactory;

    public List<LocationDto> getGroupLocations(int groupId) {

        List<LocationDto> list =
                jpaQueryFactory
                        .select(
                                Projections.bean(
                                        LocationDto.class,
                                        transactionDetail.transactionId,
                                        receipt.location,
                                        receipt.businessName.as("storeName")))
                        .from(receipt)
                        .join(transactionDetail)
                        .on(receipt.transaction.eq(transactionDetail.transaction))
                        .where(
                                transactionDetail
                                        .group
                                        .groupId
                                        .eq(groupId)
                                        .and(receipt.visibility.isTrue())
                                        .and(receipt.location.ne(""))
                                        .and(receipt.location.isNotNull()))
                        .orderBy(receipt.transactionDate.asc(), receipt.transactionTime.asc())
                        .fetch();

        log.info("locationQuery list: {}", list);
        return list;
    }
}
