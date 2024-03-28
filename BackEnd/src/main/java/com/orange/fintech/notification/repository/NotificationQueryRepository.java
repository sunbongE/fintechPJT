package com.orange.fintech.notification.repository;

import static com.orange.fintech.member.entity.QMember.*;

import com.orange.fintech.member.entity.Member;
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

        List<Member> result =
                queryFactory
                        .select(Projections.bean(Member.class, member.fcmToken))
                        .from(member)
                        .where(member.kakaoId.in(kakaoIdList))
                        .fetch();

        List<String> response = new ArrayList<>();

        for (Member member : result) {
            response.add(member.getFcmToken());
        }
        return response;
    }
}
