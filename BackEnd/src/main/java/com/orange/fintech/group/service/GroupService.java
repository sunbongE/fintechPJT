package com.orange.fintech.group.service;

import com.orange.fintech.group.dto.*;
import com.orange.fintech.group.entity.Group;
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

    void firstcall(int groupId, String memberId) throws IOException;

    boolean secondcall(int groupId, String memberId);

    void finalCalculate(int groupId, String memberId);

    List<GroupMembersDto> firstcallMembers(int groupId);

    List<GroupMembersDto> secondcallMembers(int groupId);

    List<GroupCalculateResultDto> getCalculateResult(int groupId);

    boolean isExistMember(String memberId, int groupId);
}
