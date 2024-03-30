package com.orange.fintech.auth.controller;

import com.orange.fintech.auth.dto.JoinDto;
import com.orange.fintech.auth.service.JoinService;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.io.IOException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.parser.ParseException;
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
        @ApiResponse(responseCode = "200", description = "정상 로그인"),
        @ApiResponse(responseCode = "200", description = "정상 로그인 (FCM 토큰 없음)"),
        @ApiResponse(responseCode = "201", description = "신규 가입"),
        @ApiResponse(responseCode = "201", description = "신규 가입 (FCM 토큰 없음)"),
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

        // FCM Token은 삭제하지 않는다.
        if (memberService.logout(accessToken, fcmToken)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "로그아웃 되었습니다."));
        }

        return ResponseEntity.ok(BaseResponseBody.of(500, "로그아웃 실패"));
    }

    @GetMapping("/test/token")
    @Operation(summary = "jwt token 생성기", description = "token 생성")
    public ResponseEntity<?> token(
            @Parameter(description = "name") @RequestParam String name,
            @Parameter(description = "kakao_id") @RequestParam String kakaoId) {
        String accessToken =
                jWTUtil.createAccessToken(
                        name, kakaoId, Date.from(Instant.now().plus(30, ChronoUnit.DAYS)));

        return ResponseEntity.status(200).body(accessToken);
    }

    @GetMapping("/test")
    public ResponseEntity<?> test() throws ParseException, IOException {
                return ResponseEntity.ok(BaseResponseBody.of(200, "연결댐"));
    }
}
