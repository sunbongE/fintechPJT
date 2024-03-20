package com.orange.fintech.group.repository;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupMember;
import com.orange.fintech.group.entity.GroupMemberPK;
import com.orange.fintech.member.entity.Member;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupMemberRepository extends JpaRepository<GroupMember, GroupMemberPK> {
    List<GroupMember> findByGroupMemberPKMemberAndStateIsTrue(Member member);
//    List<GroupMember> findByGroupMemberPKMemberAndStateIsTrue(Member member);

    @Override
    boolean existsById(GroupMemberPK groupMemberPK);

    int countByGroupMemberPKGroup(Group group);
}
