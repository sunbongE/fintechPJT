package com.orange.fintech.notification;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.common.net.HttpHeaders;
import com.orange.fintech.notification.Dto.FCMMessageDto;
import java.io.IOException;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class FcmSender {

    private final String API_URL =
            "https://fcm.googleapis.com/v1/projects/yeojung-3d522/messages:send";
    private final ObjectMapper objectMapper;

    public void sendMessageTo(FCMMessageDto fcmMessageDto) throws IOException {
        String message = makeMessage(fcmMessageDto);

        OkHttpClient client = new OkHttpClient();
        RequestBody requestBody =
                RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
        Request request =
                new Request.Builder()
                        .url(API_URL)
                        .post(requestBody)
                        .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
                        .addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
                        .build();

        Response response = client.newCall(request).execute();

        log.info("[FCM_Log] => {}", response.body().string());
    }

    private String makeMessage(FCMMessageDto fcmMessageDto)
            throws JsonParseException, JsonProcessingException {
        FcmMSG fcmMessage =
                FcmMSG.builder()
                        .message(
                                FcmMSG.Message.builder()
                                        .token(fcmMessageDto.getTargetToken())
                                        .data(fcmMessageDto.getData())
                                        .notification(
                                                FcmMSG.Notification.builder()
                                                        .title(fcmMessageDto.getTitle())
                                                        .body(fcmMessageDto.getBody())
                                                        .image(fcmMessageDto.getImage())
                                                        .build())
                                        .build())
                        .validateOnly(false)
                        .build();

        return objectMapper.writeValueAsString(fcmMessage);
    }

    private String getAccessToken() throws IOException {
        String firebaseConfigPath = "firebase/yeojung_firebase_service_key.json";

        GoogleCredentials googleCredentials =
                GoogleCredentials.fromStream(
                                new ClassPathResource(firebaseConfigPath).getInputStream())
                        .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }
}
