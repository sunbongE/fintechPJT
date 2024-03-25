package com.orange.fintech.map.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "위치 정보 Dto")
public class LocationDto {

    @Schema(description = "거래 id")
    private int transactionId;

    @Schema(description = "위치")
    private String location;
}
