package com.orange.fintech.auth.controller;

import com.orange.fintech.auth.service.JoinService;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    @Autowired private final JoinService joinService;

    @Autowired
    MemberService memberService;

    @Autowired
    JWTUtil jWTUtil;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, Object> map) {
        log.info("**join Controller 호출");
        log.info("map: {}", map);

        return joinService.joinProcess(map);
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String authorization) {
        String accessToken = authorization.substring("Bearer ".length());

        if(memberService.logout(accessToken)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "Token 삭제 성공"));
        }

        return ResponseEntity.ok(BaseResponseBody.of(500, "Token 삭제 실패"));
    }
}
