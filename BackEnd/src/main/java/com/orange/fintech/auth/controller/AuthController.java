package com.orange.fintech.auth.controller;

import com.orange.fintech.auth.dto.JoinDto;
import com.orange.fintech.auth.service.JoinService;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Auth", description = "인증 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/auth")
public class AuthController {

    @Autowired private final JoinService joinService;

    @Autowired MemberService memberService;

    @Autowired JWTUtil jWTUtil;

    @PostMapping("/login")
    @Operation(summary = "회원가입 및 로그인", description = "회원가입/로그인을 한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 가입/로그인"),
        @ApiResponse(responseCode = "200", description = "FCM 토큰 없이 가입"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> login(@RequestBody JoinDto user) {

        return joinService.joinProcess(user);
    }

    @PostMapping("/logout")
    @Operation(summary = "로그아웃", description = "로그아웃을 한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 로그아웃"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> logout(
            @RequestHeader("Authorization") String authorization, String fcmToken) {
        String accessToken = authorization.substring("Bearer ".length());

        if (memberService.logout(accessToken, fcmToken)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "로그아웃 되었습니다."));
        }

        return ResponseEntity.ok(BaseResponseBody.of(500, "로그아웃 실패"));
    }

    @GetMapping("/test")
    public ResponseEntity<?> test() {

        return ResponseEntity.ok(BaseResponseBody.of(200, "연결댐"));
    }
}
