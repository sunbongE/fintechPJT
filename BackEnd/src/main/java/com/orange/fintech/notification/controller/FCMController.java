package com.orange.fintech.notification.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.FcmSender;
import com.orange.fintech.notification.service.FcmService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.io.IOException;
import java.security.Principal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/notification")
@RequiredArgsConstructor
public class FCMController {

    private final FcmSender fcmSender;
    private final FcmService fcmService;

    //    @PostMapping
    //    public ResponseEntity<?> pushInviteMSG(@RequestBody SendFcmDto fcmDto, Principal
    // principal) throws IOException {
    //        System.out.println(
    //                fcmDto.getTargetToken() + " " + fcmDto.getTitle() + " " + fcmDto.getBody());
    //        fcmSender.sendMessageTo(fcmDto.getTargetToken(), fcmDto.getTitle(),
    // fcmDto.getBody());
    //        return ResponseEntity.ok().build();
    //    }

    @Async
    @PostMapping("/group")
    @Operation(summary = "단체 알림 보내기.", description = "알림DB저장, fcm으로 그룹 초대, 단체 알림을 보낸다.")
    public void pushListDataMSG(@RequestBody MessageListDataReqDto dto, Principal principal)
            throws IOException {
        String memberId = principal.getName();
        try {

            fcmService.pushListDataMSG(dto, memberId);
            //            return fcmService.pushListDataMSG(dto, memberId);

        } catch (Exception e) {
            e.printStackTrace();
            //            return ResponseEntity.internalServerError().body("서버 에러");
        }
    }

    @GetMapping()
    @Operation(summary = "개인 알림 받기.", description = "받은알림을 모두 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 반환"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getIndividualNotification(Principal principal) throws IOException {
        String memberId = principal.getName();
        try {

            return fcmService.getIndividualNotification(memberId);
            //            return fcmService.pushListDataMSG(dto, memberId);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
        }
    }

    //    @GetMapping("/test")
    //    public ResponseEntity<?> test() throws IOException {
    //        fcmService.test();
    //        return ResponseEntity.ok().build();
    //    }
}
