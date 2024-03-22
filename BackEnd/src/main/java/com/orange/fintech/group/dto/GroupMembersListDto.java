package com.orange.fintech.group.dto;

import java.io.Serializable;
import java.util.List;
import lombok.Data;

@Data
public class GroupMembersListDto implements Serializable {
    List<GroupMembersDto> groupMembersDtos;
}
