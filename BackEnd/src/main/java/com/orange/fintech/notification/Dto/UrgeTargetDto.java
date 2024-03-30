package com.orange.fintech.notification.Dto;

import com.orange.fintech.group.entity.GroupMemberPK;
import lombok.Data;

@Data
public class UrgeTargetDto {
    String fcmToken;
    GroupMemberPK groupMemberPK;
}
