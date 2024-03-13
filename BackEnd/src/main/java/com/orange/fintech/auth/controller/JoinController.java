package com.orange.fintech.auth.controller;

import com.orange.fintech.auth.dto.JoinDto;
import com.orange.fintech.auth.service.JoinService;
import com.orange.fintech.common.BaseResponseBody;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class JoinController {

    private final JoinService joinService;

    @PostMapping("/join")
    public ResponseEntity<?> joinProcess(@RequestBody JoinDto dto) {
        try {

            if (joinService.joinProcess(dto)) {
                return ResponseEntity.ok(BaseResponseBody.of(200, "Join Success"));
            } else {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(BaseResponseBody.of(409, "Duplicate email"));
            }
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "Server Error"));
        }
    }

    @GetMapping("/test")
    public ResponseEntity<?> test() {
        return ResponseEntity.ok("test msg");
    }
}
