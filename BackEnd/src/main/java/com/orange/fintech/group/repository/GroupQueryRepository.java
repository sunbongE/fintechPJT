package com.orange.fintech.group.repository;

import static com.orange.fintech.group.entity.QGroup.*;
import static com.orange.fintech.group.entity.QGroupMember.*;
import static com.orange.fintech.member.entity.QMember.*;

import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.repository.MemberRepository;
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
public class GroupQueryRepository {

    private final GroupRepository groupRepository;
    private final JPAQueryFactory queryFactory;
    private final MemberRepository memberRepository;

    public List<Group> findAllMyGroup(String kakaoId) {

        return queryFactory
                .select(
                        Projections.bean(
                                Group.class,
                                group.groupId,
                                group.groupName,
                                group.theme,
                                group.startDate,
                                group.endDate,
                                group.isCalculateDone))
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

    public List<GroupMembersDto> findGroupMembers(int groupId) {
        List<GroupMembersDto> groupList = new ArrayList<>();
        groupList =
                queryFactory
                        .select(
                                Projections.bean(
                                        GroupMembersDto.class,
                                        member.kakaoId,
                                        member.name,
                                        member.thumbnailImage))
                        .from(member)
                        .leftJoin(groupMember)
                        .on(groupMember.groupMemberPK.member.eq(member))
                        .where(groupMember.groupMemberPK.group.groupId.eq(groupId))
                        .fetch();
        return groupList;
    }

    public List<GroupMembersDto> firstcallMembers(int groupId) {
        List<GroupMembersDto> result = new ArrayList<>();

        result =
                queryFactory
                        .select(
                                Projections.bean(
                                        GroupMembersDto.class,
                                        member.kakaoId,
                                        member.name,
                                        member.thumbnailImage))
                        .from(member)
                        .leftJoin(groupMember)
                        .on(groupMember.groupMemberPK.member.kakaoId.eq(member.kakaoId))
                        .where(
                                groupMember.groupMemberPK.group.groupId.eq(groupId),
                                groupMember.fistCallDone.eq(true))
                        .fetch();

        return result;
    }

    public List<GroupMembersDto> secondcallMembers(int groupId) {
        List<GroupMembersDto> result = new ArrayList<>();

        result =
                queryFactory
                        .select(
                                Projections.bean(
                                        GroupMembersDto.class,
                                        member.kakaoId,
                                        member.name,
                                        member.thumbnailImage))
                        .from(member)
                        .leftJoin(groupMember)
                        .on(groupMember.groupMemberPK.member.kakaoId.eq(member.kakaoId))
                        .where(
                                groupMember.groupMemberPK.group.groupId.eq(groupId),
                                groupMember.secondCallDone.eq(true))
                        .fetch();

        return result;
    }

    public List<Group> findAllMyGroupId(String kakaoId) {
        return queryFactory
                .select(
                        Projections.bean(
                                Group.class,
                                group.groupId
                                ))
                .from(group)
                .leftJoin(groupMember)
                .on(group.groupId.eq(groupMember.groupMemberPK.group.groupId))
                .where(
                        groupMember
                                .groupMemberPK
                                .member
                                .kakaoId
                                .eq(kakaoId)
                                )
                .fetch();
    }
}
