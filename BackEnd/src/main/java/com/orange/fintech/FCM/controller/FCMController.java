package com.orange.fintech.FCM.controller;

import com.orange.fintech.FCM.Dto.FCMDto;
import com.orange.fintech.FCM.FCMService;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/fcm")
@RequiredArgsConstructor
public class FCMController {

    private final FCMService fcmService;

    @PostMapping
    public ResponseEntity<?> pushMSG(@RequestBody FCMDto fcmDto) throws IOException {
        System.out.println(
                fcmDto.getTargetToken() + " " + fcmDto.getTitle() + " " + fcmDto.getBody());
        fcmService.sendMessageTo(fcmDto.getTargetToken(), fcmDto.getTitle(), fcmDto.getBody());
        return ResponseEntity.ok().build();
    }
}
