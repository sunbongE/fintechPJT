package com.orange.fintech.notification.Dto;

import com.orange.fintech.notification.entity.NotificationType;
import java.util.List;
import lombok.Data;

@Data
public class MessageListDataReqDto {
    // kakaoIdList
    private List<String> targetMembers;
    private int groupId;
    private NotificationType notificationType;
}
