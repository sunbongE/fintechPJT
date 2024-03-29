package com.orange.fintech.notification.Dto;

import com.orange.fintech.notification.entity.NotificationType;
import lombok.Data;

@Data
public class MessageReqDto {

    //    private String senderId; principal에서 추출.
    private String receiverId;
    private String groupId;
    private NotificationType notificationType;
}
