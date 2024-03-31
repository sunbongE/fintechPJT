package com.orange.fintech.dummy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@RequiredArgsConstructor
public class UserKeyAccountPair {
    @Schema(description = "여정 DB Member 테이블 PK")
    private String kakaoId;

    @Schema(description = "SSAFY 교육용 금융망 API userKey")
    private String userKey;

    @Schema(description = "SSAFY 교육용 금융망 API accountNo")
    private String accountNo;
}
