package com.orange.fintech.api.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.api.dto.JoinDto;
import com.orange.fintech.api.service.JoinService;
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
    public ResponseEntity<?> joinProcess(@RequestBody JoinDto dto){
        try {

            if(joinService.joinProcess(dto)){
                return ResponseEntity.ok(BaseResponseBody.of(200,"Join Success"));
            }
            else {
                return ResponseEntity.status(HttpStatus.CONFLICT).body(BaseResponseBody.of(409,"Duplicate email"));
            }
        }catch (Exception e){
            log.info(e.getMessage());
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "Server Error"));
        }
    }

}
