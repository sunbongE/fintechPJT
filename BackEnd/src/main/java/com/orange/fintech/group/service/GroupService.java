package com.orange.fintech.group.service;

import com.orange.fintech.group.dto.GroupCreateDto;
import com.orange.fintech.group.dto.ModifyGroupDto;
import com.orange.fintech.group.entity.Group;
import java.util.List;

public interface GroupService {
    boolean createGroup(GroupCreateDto dto);

    List<Group> findGroups(String memberId);

    Group getGroup(int groupId);

    boolean check(String memberId, int groupId);

    Group modifyGroup(int groupId, ModifyGroupDto dto);

    boolean leaveGroup(int groupId, String memberId);

    boolean joinGroup(int groupId, String memberId);
}
