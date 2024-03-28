package com.orange.fintech.notification.repository;

import static com.orange.fintech.member.entity.QFcmToken.*;
import static com.orange.fintech.member.entity.QMember.*;

import com.orange.fintech.member.entity.FcmToken;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Repository
@RequiredArgsConstructor
@Transactional
public class NotificationQueryRepository {

    private final JPAQueryFactory queryFactory;

    public List<String> getMembersFcmToken(List<String> kakaoIdList) {

        List<FcmToken> result =
                queryFactory
                        .select(Projections.bean(FcmToken.class, fcmToken1.fcmToken))
                        .from(fcmToken1)
                        .where(fcmToken1.member.kakaoId.in(kakaoIdList))
                        .fetch();

        List<String> response = new ArrayList<>();

        for (FcmToken dto : result) {
            response.add(dto.getFcmToken());
        }
        return response;
    }
}
