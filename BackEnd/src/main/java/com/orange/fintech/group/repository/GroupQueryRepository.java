package com.orange.fintech.group.repository;

import static com.orange.fintech.group.entity.QGroup.*;
import static com.orange.fintech.group.entity.QGroupMember.*;
import static com.orange.fintech.member.entity.QFcmToken.*;
import static com.orange.fintech.member.entity.QMember.*;

import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupMemberPK;
import com.orange.fintech.group.entity.GroupStatus;
import com.orange.fintech.member.entity.FcmToken;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.notification.Dto.UrgeTargetDto;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Repository
@RequiredArgsConstructor
@Transactional
public class GroupQueryRepository {

    private final JPAQueryFactory queryFactory;

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
                                group.groupStatus))
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

    public List<String> findGroupMembersKakaoId(int groupId) {
        List<String> groupMembersKakaoId = new ArrayList<>();

        List<GroupMembersDto> groupMembersDtos =
                queryFactory
                        .select(Projections.bean(GroupMembersDto.class, member.kakaoId))
                        .from(member)
                        .leftJoin(groupMember)
                        .on(groupMember.groupMemberPK.member.eq(member))
                        .where(groupMember.groupMemberPK.group.groupId.eq(groupId))
                        .fetch();
        for (GroupMembersDto groupMembersDto : groupMembersDtos) {
            groupMembersKakaoId.add(groupMembersDto.getKakaoId());
        }
        return groupMembersKakaoId;
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

    public List<GroupMembersDto> firstcallMembersOnlyKakaoId(int groupId) {
        List<GroupMembersDto> result = new ArrayList<>();

        result =
                queryFactory
                        .select(Projections.bean(GroupMembersDto.class, member.kakaoId))
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
                .select(Projections.bean(Group.class, group.groupId))
                .from(group)
                .leftJoin(groupMember)
                .on(group.groupId.eq(groupMember.groupMemberPK.group.groupId))
                .where(groupMember.groupMemberPK.member.kakaoId.eq(kakaoId))
                .fetch();
    }

    /**
     * @param groupId
     * @return 그룹에 있는 전체 인원수를 리턴안다.
     */
    public int countGroupMembers(int groupId) {

        return (int)
                queryFactory
                        .select(groupMember)
                        .from(groupMember)
                        .where(groupMember.groupMemberPK.group.groupId.eq(groupId))
                        .fetchCount();
    }
    /**
     * @param groupId
     * @return 그룹에 있는 1차 정산요청을 보낸 인원수를 리턴안다.
     */
    public int countFirstcallGroupMembers(int groupId) {
        return (int)
                queryFactory
                        .select(groupMember)
                        .from(groupMember)
                        .where(
                                groupMember.groupMemberPK.group.groupId.eq(groupId),
                                groupMember.fistCallDone)
                        .fetchCount();
    }

    public int countSecondcallGroupMembers(int groupId) {
        return (int)
                queryFactory
                        .select(groupMember)
                        .from(groupMember)
                        .where(
                                groupMember.groupMemberPK.group.groupId.eq(groupId),
                                groupMember.secondCallDone)
                        .fetchCount();
    }

    /**
     * @param groupId
     * @return 그룹에 있는 모든 회원의 fcmToken을 보내준다.
     */
    public List<String> findAllGroupMembersFcmToken(int groupId) {
        List<FcmToken> fcmTokens =
                queryFactory
                        .select(fcmToken1)
                        .from(fcmToken1)
                        .where(
                                fcmToken1.member.kakaoId.in(
                                        JPAExpressions.select(
                                                        groupMember.groupMemberPK.member.kakaoId)
                                                .from(groupMember)
                                                .where(
                                                        groupMember.groupMemberPK.group.groupId.eq(
                                                                groupId))))
                        .fetch();

        List<String> result = new ArrayList<>();
        for (FcmToken fcmToken : fcmTokens) {
            result.add(fcmToken.getFcmToken());
        }

        log.info("토큰들 잘 나오나? =>{}", result);
        return result;
    }

    public String getGroupName(int groupId) {
        return queryFactory
                .select(group.groupName)
                .from(group)
                .where(group.groupId.eq(groupId))
                .fetchFirst();
    }

    public List<UrgeTargetDto> findAllUrgeFcmtoken() {
        LocalDate currentDate = LocalDate.now();

        List<Tuple> fetch =
                queryFactory
                        .select(fcmToken1.fcmToken, groupMember.groupMemberPK)
                        .from(fcmToken1)
                        .innerJoin(groupMember)
                        .on(groupMember.groupMemberPK.member.eq(fcmToken1.member))
                        .leftJoin(group)
                        .on(groupMember.groupMemberPK.group.groupId.eq(group.groupId))
                        .where(
                                group.groupStatus
                                        .eq(GroupStatus.DONE)
                                        .and(group.endDate.before(currentDate)))
                        .fetch();

        List<UrgeTargetDto> result = new ArrayList<>();
        for (Tuple tuple : fetch) {
            UrgeTargetDto dto = new UrgeTargetDto();
            dto.setFcmToken(tuple.get(fcmToken1.fcmToken));
            dto.setGroupMemberPK(tuple.get(groupMember.groupMemberPK));
            result.add(dto);
        }

        return result;
    }

    public boolean isSplit(int groupId, String memberId) {
        Group tmpGroup = new Group();
        tmpGroup.setGroupId(groupId);
        Member tmpMember = new Member();
        tmpMember.setKakaoId(memberId);

        GroupMemberPK tmpGroupMemberPK = new GroupMemberPK();
        tmpGroupMemberPK.setGroup(tmpGroup);
        tmpGroupMemberPK.setMember(tmpMember);

        return Objects.equals(
                queryFactory
                        .select(groupMember.fistCallDone)
                        .from(groupMember)
                        .leftJoin(group)
                        .on(group.groupId.eq(groupMember.groupMemberPK.group.groupId))
                        .where(groupMember.groupMemberPK.eq(tmpGroupMemberPK))
                        .fetchOne(),
                true);
    }
}
