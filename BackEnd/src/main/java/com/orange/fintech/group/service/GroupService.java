package com.orange.fintech.group.service;

import com.orange.fintech.group.dto.*;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupStatus;
import java.io.IOException;
import java.util.List;

public interface GroupService {
    int createGroup(GroupCreateDto dto, String memberId);

    List<Group> findGroups(String memberId);

    Group getGroup(int groupId);

    boolean check(String memberId, int groupId);

    Group modifyGroup(int groupId, ModifyGroupDto dto);

    boolean leaveGroup(int groupId, String memberId);

    boolean joinGroup(int groupId, String memberId);

    GroupMembersListDto findGroupMembers(int groupId);

    boolean firstcall(int groupId, String memberId) throws IOException;

    int secondcall(int groupId, String memberId);

    List<GroupMembersDto> firstcallMembers(int groupId);

    List<GroupMembersDto> secondcallMembers(int groupId);

    List<GroupCalculateResultDto> getCalculateResult(int groupId);

    boolean isExistMember(String memberId, int groupId);

    String checkMyStatus(int groupId, String memberId);

    GroupStatus getGroupStatus(int groupId);

    boolean isSplit(int groupId, String memberId);
}
