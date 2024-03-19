package com.orange.fintech.group.service.serviceImpl;

import com.orange.fintech.group.dto.GroupCreateDto;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupMemberPK;
import com.orange.fintech.group.repository.GroupMemberRepository;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class GroupServiceImpl implements GroupService {
    private final GroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;
    private final MemberRepository memberRepository;
    private final GroupQueryRepository groupQueryRepository;

    @Override
    public boolean createGroup(GroupCreateDto dto) {
        Group data = new Group(dto);
        groupRepository.save(data);
        return true;
    }

    @Override
    public List<Group> findGroups(String memberId) {
        Member member = memberRepository.findByKakaoId(memberId);
        log.info("member : {} ", member);
        //        return groupMemberRepository.findByGroupMemberPKMemberAndStateIsTrue(member);
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
}
