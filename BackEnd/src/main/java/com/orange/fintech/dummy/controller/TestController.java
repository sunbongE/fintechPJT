package com.orange.fintech.dummy.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.dummy.dto.UserKeyAccountPair;
import com.orange.fintech.dummy.service.TestService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.nio.file.Paths;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Test", description = "테스트 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/test")
public class TestController {
    private final TestService testService;

    @GetMapping("/path")
    @Operation(
            summary =
                    "현재 경로 반환",
            description =
                    "현재 경로 반환")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> path() {
        return ResponseEntity.status(200).body(BaseResponseBody.of(200, Paths.get("").toAbsolutePath().toString()));
    }

    @PostMapping("/postdummytranaction")
    @Operation(
            summary =
                    "SSAFY Bank API 이용 더미 데이터 결제 내역 추가 (Docker 실행이 중지되지 않을 때 또는 localhost에서 실행해야 함!)",
            description =
                    "<strong>SSAFY Bank API</strong>를 이용해 더미 데이터 결제 내역을 추가한다.<br>(Docker 실행이 중지되지 않을 때 또는 localhost에서 실행해야 함!)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> postDummyTranaction(
            @RequestBody List<UserKeyAccountPair> userKeyAccountPairList) {
        log.info("userKeyAccountPairList");
        log.info(userKeyAccountPairList.toString());

        try {
            testService.postDummyTranaction(userKeyAccountPairList);

            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "더미 데이터가 정상 추가되었습니다."));
        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "더미 데이터 추가를 실패했습니다."));
        }
    }
}
