package com.orange.fintech.group.service;

import com.orange.fintech.group.dto.GroupCalculateResultDto;
import com.orange.fintech.group.dto.GroupCreateDto;
import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.dto.ModifyGroupDto;
import com.orange.fintech.group.entity.CalculateResult;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupMember;
import com.orange.fintech.group.entity.GroupMemberPK;
import com.orange.fintech.group.repository.CalculateResultRepository;
import com.orange.fintech.group.repository.GroupMemberRepository;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
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
    private final GroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;
    private final MemberRepository memberRepository;
    private final GroupQueryRepository groupQueryRepository;
    private final CalculateResultRepository calculateResultRepository;

    @Override
    public boolean createGroup(GroupCreateDto dto, String memberId) {
        Group data = new Group(dto);
        Group group = groupRepository.save(data);

        joinGroup(group.getGroupId(), memberId);

        return true;
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
        if (group.getIsCalculateDone()
                || groupMemberRepository.countByGroupMemberPKGroup(group) == 1) {
            Member member = memberRepository.findById(memberId).get();
            GroupMemberPK groupMemberPK = new GroupMemberPK(member, group);
            GroupMember groupMember = groupMemberRepository.findById(groupMemberPK).get();
            groupMember.setState(false);
            groupMemberRepository.save(groupMember);
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
        return true;
    }

    @Override
    public List<GroupMembersDto> findGroupMembers(int groupId) {
        List<GroupMembersDto> result = groupQueryRepository.findGroupMembers(groupId);
        return result;
    }

    @Override
    public boolean firstcall(int groupId, String memberId) {

        Group group = new Group();
        Member member = new Member();
        group.setGroupId(groupId);
        member.setKakaoId(memberId);

        GroupMemberPK groupMemberPK = new GroupMemberPK(member, group);
        Optional<GroupMember> Optarget = groupMemberRepository.findById(groupMemberPK);
        if (Optarget.isEmpty()) return false;

        GroupMember target = Optarget.get();
        target.setFistCallDone(!target.getFistCallDone());

        groupMemberRepository.save(target);

        return true;
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

        GroupMember target = Optarget.get();

        if (!target.getFistCallDone()) return false;

        target.setSecondCallDone(!target.getSecondCallDone());

        groupMemberRepository.save(target);

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

    // Todo : Dto를 만들 때 회원을 전부 조회하는 쿼리가 발생하고 필요 이상의 데이터를 조회하기 때문에 최적화를 고려할만 하다.
    @Override
    public List<GroupCalculateResultDto> getCalculateResult(int groupId) {
        List<CalculateResult> calculateResultList = new ArrayList<>();
        Optional<Group> OpGroup = groupRepository.findById(groupId);

        if (OpGroup.isEmpty()) return null;
        Group group = OpGroup.get();
        calculateResultList = calculateResultRepository.findAllByGroup(group);

        List<GroupCalculateResultDto> result = new ArrayList<>();

        for (CalculateResult calculateResult : calculateResultList) {
            GroupCalculateResultDto data =
                    new GroupCalculateResultDto(calculateResult); // <=== 이부분.
            result.add(data);
        }

        return result;
    }
}
