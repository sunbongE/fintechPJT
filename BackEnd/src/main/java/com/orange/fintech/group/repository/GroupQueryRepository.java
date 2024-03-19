package com.orange.fintech.group.repository;

import static com.orange.fintech.group.entity.QGroup.*;
import static com.orange.fintech.group.entity.QGroupMember.*;

import com.orange.fintech.group.entity.Group;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class GroupQueryRepository {

    private final EntityManager em;

    private final JPAQueryFactory queryFactory;

    public List<Group> findAllMyGroup(String kakaoId) {
        kakaoId = "3388366548";

        return queryFactory
                .select(
                        Projections.bean(
                                Group.class,
                                group.groupId,
                                group.groupName,
                                group.startDate,
                                group.endDate))
                .from(group)
                .leftJoin(groupMember)
                .on(group.groupId.eq(groupMember.groupMemberPK.group.groupId))
                .where(
                        groupMember
                                .groupMemberPK
                                .member
                                .kakaoId
                                .eq(kakaoId)
                                .and(groupMember.state.eq(true)))
                .fetch();
    }
}
