package com.orange.fintech.notification.Dto;

import java.util.Map;
import lombok.Data;

@Data
public class FCMMessageDto {

    private String targetToken;
    private String title;
    private String body;
    private String image;
    private Map<String, String> data;

    public FCMMessageDto() {}

    public FCMMessageDto(String fcmToken, String title, String body, Map<String, String> dataSet) {
        this.targetToken = fcmToken;
        this.title = title;
        this.body = body;
        this.data = dataSet;
    }
}
