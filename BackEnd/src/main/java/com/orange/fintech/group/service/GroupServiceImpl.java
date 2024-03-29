package com.orange.fintech.group.service;

import com.orange.fintech.group.dto.*;
import com.orange.fintech.group.entity.*;
import com.orange.fintech.group.repository.CalculateResultRepository;
import com.orange.fintech.group.repository.GroupMemberRepository;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.FcmSender;
import com.orange.fintech.notification.entity.NotificationType;
import com.orange.fintech.notification.repository.NotificationQueryRepository;
import com.orange.fintech.notification.service.FcmService;
import com.orange.fintech.payment.entity.TransactionDetail;
import com.orange.fintech.payment.entity.TransactionMember;
import com.orange.fintech.payment.entity.TransactionMemberPK;
import com.orange.fintech.payment.repository.TransactionDetailRepository;
import com.orange.fintech.payment.repository.TransactionMemberRepository;
import com.orange.fintech.redis.service.GroupRedisService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class GroupServiceImpl implements GroupService {
    private final FcmSender fcmSender;
    private final FcmService fcmService;
    private final GroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;
    private final MemberRepository memberRepository;
    private final GroupQueryRepository groupQueryRepository;
    private final CalculateResultRepository calculateResultRepository;
    private final GroupRedisService groupRedisService;
    private final TransactionDetailRepository transactionDetailRepository;
    private final TransactionMemberRepository transactionMemberRepository;
    private final NotificationQueryRepository notificationQueryRepository;

    @Override
    public int createGroup(GroupCreateDto dto, String memberId) {
        Group data = new Group(dto);
        Group group = groupRepository.save(data);

        joinGroup(group.getGroupId(), memberId);

        return group.getGroupId();
    }

    @Override
    public List<Group> findGroups(String memberId) {
        return groupQueryRepository.findAllMyGroup(memberId);
    }

    @Override
    public Group getGroup(int groupId) {
        Optional<Group> OpGroup = groupRepository.findById(groupId);

        return OpGroup.get();
    }

    @Override
    public boolean check(String memberId, int groupId) {
        Member member = new Member();
        member.setKakaoId(memberId);
        Group group = new Group();
        group.setGroupId(groupId);

        GroupMemberPK groupMemberPK = new GroupMemberPK();
        groupMemberPK.setGroup(group);
        groupMemberPK.setMember(member);

        return groupMemberRepository.existsById(groupMemberPK);
    }

    @Override
    public Group modifyGroup(int groupId, ModifyGroupDto dto) {

        // 바꿀 데이터 가져오기.
        Optional<Group> opGroup = groupRepository.findById(groupId);
        Group changeGroup = new Group();

        if (opGroup.isPresent()) {
            changeGroup = opGroup.get();
            changeGroup.setGroupName(dto.getGroupName());
            changeGroup.setTheme(dto.getTheme());
            changeGroup.setStartDate(dto.getStartDate());
            changeGroup.setEndDate(dto.getEndDate());
            groupRepository.save(changeGroup);
        }

        return changeGroup;
    }

    /**
     * 그룹이 정산이 완료되었거나, 인원이 한명인 경우는 바로 나가기 가능.
     *
     * @param groupId
     * @param memberId
     * @return
     */
    @Override
    public boolean leaveGroup(int groupId, String memberId) {
        Group group = groupRepository.findById(groupId).get();
        if (group.getGroupStatus().equals(GroupStatus.DONE)
                || groupMemberRepository.countByGroupMemberPKGroup(group) == 1) {
            Member member = memberRepository.findById(memberId).get();
            GroupMemberPK groupMemberPK = new GroupMemberPK(member, group);
            GroupMember groupMember = groupMemberRepository.findById(groupMemberPK).get();
            groupMember.setState(false);
            groupMemberRepository.save(groupMember);

            groupRedisService.deleteData(groupId);
            return true;
        }
        return false;
    }

    @Override
    public boolean joinGroup(int groupId, String memberId) {
        Group group = new Group();
        group.setGroupId(groupId);
        Member member = new Member();
        member.setKakaoId(memberId);

        GroupMemberPK groupMemberPK = new GroupMemberPK(member, group);

        GroupMember data = new GroupMember();
        data.setGroupMemberPK(groupMemberPK);

        groupMemberRepository.save(data);

        addAllTransactionMember(group, member);

        // 여기서 캐시 날려주셈
        groupRedisService.deleteData(groupId);

        return true;
    }

    public void addAllTransactionMember(Group group, Member member) {

        List<TransactionDetail> transactionDetails = transactionDetailRepository.findByGroup(group);
        for (TransactionDetail transactionDetail : transactionDetails) {
            TransactionMemberPK pk = new TransactionMemberPK();
            pk.setTransaction(transactionDetail.getTransaction());
            pk.setMember(member);

            TransactionMember transactionMember = new TransactionMember();
            transactionMember.setTransactionMemberPK(pk);
            transactionMember.setIsLock(false);
            transactionMember.setTotalAmount(0L);

            transactionMemberRepository.save(transactionMember);
        }
    }

    @Override
    public GroupMembersListDto findGroupMembers(int groupId) {
        GroupMembersListDto result;
        // 1. 캐시에서 그룹원을 조회한다.
        result = groupRedisService.getGroupMembersFromCache(groupId);

        if (result == null) {
            log.info("** DB에서 호출 ===============");
            // 2. 캐시에 없으면 DB에서 가져온다.
            result = new GroupMembersListDto();
            result.setGroupMembersDtos(groupQueryRepository.findGroupMembers(groupId));
            //            result.setGroupMembersDtos((List<GroupMembersDto>)
            // groupQueryRepository.findGroupMembers(groupId));

            // 3. DB에 조회한 그룹원을 캐시에 저장한다.
            groupRedisService.saveDataExpire(groupId, result);
        }

        //        List<GroupMembersDto> groupMembersDtos =
        // groupQueryRepository.findGroupMembers(groupId);

        //        result.setGroupMembersDtos(groupMembersDtos);

        //        result = groupQueryRepository.findGroupMembers(groupId);
        //        groupRedisService.deleteData(groupId); // 삭제
        //        groupRedisService.saveDataExpire(groupId, result); // 저장
        //        log.info("캐시된값 : {}",groupRedisService.getGroupMembersFromCache(groupId));
        return result;
    }

    @Override
    public void firstcall(int groupId, String memberId) throws IOException {
        Group group = new Group();
        Member member = new Member();
        group.setGroupId(groupId);
        member.setKakaoId(memberId);

        GroupMemberPK groupMemberPK = new GroupMemberPK(member, group);
        Optional<GroupMember> Optarget = groupMemberRepository.findById(groupMemberPK);
        if (Optarget.isEmpty()) return;

        GroupMember targetGroupMember = Optarget.get();
        targetGroupMember.setFistCallDone(!targetGroupMember.getFistCallDone());

        groupMemberRepository.save(targetGroupMember);
        // Todo : 여행정산요청을 그룹에 포함된 모든 회원들에게 보낸다.(DATA : groupId)
        // A : 같은 그룹에 1차 정산 내역 요청을 누른 사람들
        int countFirstcallGroupMembers = groupQueryRepository.countFirstcallGroupMembers(groupId);
        // T : 같은 그룹에 전체 인원수
        int countGroupMembers = groupQueryRepository.countGroupMembers(groupId);

        log.info("전체인원 : {}, 1차 누른 인원: {}", countGroupMembers, countFirstcallGroupMembers);

        // A와 T가 같은지 비교해서 같으면 알림fcm 함수를 실행시킨다.
        if (countGroupMembers == countFirstcallGroupMembers) {
            // Todo : fcm보내버리기~~~~~~~~ 현재회원이 들어간 그룹의 그룹원들의 kakaoId를 이용해서 fcm_token추출

            List<GroupMembersDto> groupMembersDtos =
                    groupQueryRepository.firstcallMembersOnlyKakaoId(groupId);
            List<String> kakaoIdList = new ArrayList<>();
            for (GroupMembersDto groupMembersDto : groupMembersDtos) {
                kakaoIdList.add(groupMembersDto.getKakaoId());
            }
            log.info("결과들 : {}", kakaoIdList);
            MessageListDataReqDto messageListDataReqDto = new MessageListDataReqDto();
            messageListDataReqDto.setGroupId(groupId);
            messageListDataReqDto.setInviteMembers(kakaoIdList);
            messageListDataReqDto.setNotificationType(NotificationType.SPLIT);

            fcmService.pushListDataMSG(messageListDataReqDto);

            log.info("다 보냈어 ");
        }
        //        throw new RuntimeException("일단 멈춰봐.");
        //        return true;
    }

    @Override
    public boolean secondcall(int groupId, String memberId) {
        Group group = new Group();
        Member member = new Member();
        group.setGroupId(groupId);
        member.setKakaoId(memberId);

        GroupMemberPK groupMemberPK = new GroupMemberPK(member, group);
        Optional<GroupMember> Optarget = groupMemberRepository.findById(groupMemberPK);
        if (Optarget.isEmpty()) return false;

        GroupMember targetGroupMember = Optarget.get();

        if (!targetGroupMember.getFistCallDone()) return false;

        targetGroupMember.setSecondCallDone(!targetGroupMember.getSecondCallDone());

        groupMemberRepository.save(targetGroupMember);

        return true;
    }

    @Override
    public List<GroupMembersDto> firstcallMembers(int groupId) {
        List<GroupMembersDto> result = groupQueryRepository.firstcallMembers(groupId);
        return result;
    }

    @Override
    public List<GroupMembersDto> secondcallMembers(int groupId) {
        List<GroupMembersDto> result = groupQueryRepository.secondcallMembers(groupId);
        return result;
    }

    // Todo : Dto를 만들 때 회원을 전부 조회하는 쿼리가 발생하고 필요 이상의 데이터를 조회하기 때문에 최적화를 고려할만 하다. N+1문제
    @Override
    public List<GroupCalculateResultDto> getCalculateResult(int groupId) {
        List<CalculateResult> calculateResultList = new ArrayList<>();
        Optional<Group> OpGroup = groupRepository.findById(groupId);

        if (OpGroup.isEmpty()) return null;
        Group group = OpGroup.get();
        calculateResultList = calculateResultRepository.findAllByGroup(group);

        List<GroupCalculateResultDto> result = new ArrayList<>();

        for (CalculateResult calculateResult : calculateResultList) {
            //            log.info("DB 호출되나?");
            GroupCalculateResultDto data =
                    new GroupCalculateResultDto(calculateResult); // <=== 이부분.
            result.add(data);
        }

        return result;
    }

    /**
     * 회원이 그룹에 포함되어있는지 확인하거나 그룹이 존재하는지 확인한다.
     *
     * @param memberId
     * @param groupId
     * @return
     */
    @Override
    public boolean isExistMember(String memberId, int groupId) {

        // 회원이 선택한 그룹의 존재여부와 포함되어(권한)있는지 확인.
        if (!check(memberId, groupId)) {
            return false;
        }
        return true;
    }
}
