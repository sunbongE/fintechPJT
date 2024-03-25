package com.orange.fintech.map.controller;

import com.orange.fintech.map.dto.LocationDto;
import com.orange.fintech.map.service.MapService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Tag(name = "Map", description = "지도 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/maps")
public class MapController {

    private final MapService mapService;

    @GetMapping("/group/{groupId}")
    @Operation(summary = "그룹의 결제 위치 목록 불러오기", description = "<strong>그룹 아이디</strong>로 위치 목록을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<List<LocationDto>> getMyTransactionList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            Principal principal) {

        try {
            List<LocationDto> res = mapService.getLocations(groupId);
            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {

            return ResponseEntity.status(400).body(null);
        }

    }
}
