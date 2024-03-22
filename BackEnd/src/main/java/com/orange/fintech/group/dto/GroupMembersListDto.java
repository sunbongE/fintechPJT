package com.orange.fintech.group.dto;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

@Data
public class GroupMembersListDto implements Serializable {
    List<GroupMembersDto> groupMembersDtos;
}

