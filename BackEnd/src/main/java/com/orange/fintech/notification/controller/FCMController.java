// package com.orange.fintech.notification.controller;
//
// import com.orange.fintech.notification.Dto.messageListDataReqDto;
// import com.orange.fintech.notification.FcmSender;
// import com.orange.fintech.notification.service.FcmService;
// import io.swagger.v3.oas.annotations.Operation;
// import io.swagger.v3.oas.annotations.responses.ApiResponse;
// import io.swagger.v3.oas.annotations.responses.ApiResponses;
// import java.io.IOException;
// import java.security.Principal;
// import lombok.RequiredArgsConstructor;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;
//
// @RestController
// @RequestMapping("/api/v1/notification")
// @RequiredArgsConstructor
// public class FCMController {
//
//    private final FcmSender fcmSender;
//    private final FcmService fcmService;
//
//    //    @PostMapping
//    //    public ResponseEntity<?> pushInviteMSG(@RequestBody SendFcmDto fcmDto, Principal
//    // principal) throws IOException {
//    //        System.out.println(
//    //                fcmDto.getTargetToken() + " " + fcmDto.getTitle() + " " + fcmDto.getBody());
//    //        fcmSender.sendMessageTo(fcmDto.getTargetToken(), fcmDto.getTitle(),
// fcmDto.getBody());
//    //        return ResponseEntity.ok().build();
//    //    }
//
//    @PostMapping("/group")
//    @Operation(summary = "단체 알림 보내기.", description = "알림DB저장, fcm으로 그룹 초대, 단체 알림을 보낸다.")
//    @ApiResponses({
//        @ApiResponse(responseCode = "200", description = "정상 반환"),
//        @ApiResponse(responseCode = "400", description = "그룹이 없습니다."),
//        @ApiResponse(responseCode = "500", description = "서버 오류")
//    })
//    public ResponseEntity<?> pushListDataMSG(
//            @RequestBody messageListDataReqDto dto, Principal principal) throws IOException {
//        String memberId = principal.getName();
//        try {
//
//            return fcmService.pushListDataMSG(dto, memberId);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.internalServerError().body("서버 에러");
//        }
//    }
//
//    //    @PostMapping("/individual")
//    //    @Operation(summary = "개인 알림 보내기.", description = "알림DB저장, fcm으로 단일 알림을 보낸다.")
//    //    @ApiResponses({
//    //        @ApiResponse(responseCode = "200", description = "정상 반환"),
//    //        @ApiResponse(responseCode = "404", description = "계좌 정보 없음 (DB 레코드 유실)"),
//    //        @ApiResponse(responseCode = "500", description = "서버 오류")
//    //    })
//    //    public ResponseEntity<?> pushDataMSG(
//    //            @RequestBody messageReqDto dto, Principal principal) throws IOException {
//    //        String memberId = principal.getName();
//    //        try {
//    //
//    ////            return fcmService.pushDataMSG(dto, memberId);
//    //
//    //        } catch (Exception e) {
//    //            e.printStackTrace();
//    //            return ResponseEntity.internalServerError().body("서버 에러");
//    //        }
//    //    }
//    //
//    //    @PostMapping("/individual")
//    //    @Operation(summary = "개인 알림 조회.", description = "회원이 받은 알림을 조회한다.")
//    //    @ApiResponses({
//    //        @ApiResponse(responseCode = "200", description = "정상 반환"),
//    //        @ApiResponse(responseCode = "404", description = "계좌 정보 없음 (DB 레코드 유실)"),
//    //        @ApiResponse(responseCode = "500", description = "서버 오류")
//    //    })
//    //    public ResponseEntity<?> pushDataMSG(
//    //            @RequestBody messageReqDto dto, Principal principal) throws IOException {
//    //        String memberId = principal.getName();
//    //        try {
//    //
//    ////            return fcmService.pushDataMSG(dto, memberId);
//    //
//    //        } catch (Exception e) {
//    //            e.printStackTrace();
//    //            return ResponseEntity.internalServerError().body("서버 에러");
//    //        }
//    //    }
// }
