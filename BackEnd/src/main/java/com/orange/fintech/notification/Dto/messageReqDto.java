package com.orange.fintech.notification.Dto;

import com.orange.fintech.notification.entity.NotificationType;

public class messageReqDto {

    //    private String senderId; principal에서 추출.
    private String receiverId;
    private String groupId;
    private NotificationType notificationType;
}
