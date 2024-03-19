package com.orange.fintech.group.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDate;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Schema(name = "그룹 생성", description = "그룹생성 Dto")
public class GroupCreateDto {

    @Schema(name = "groupName", example = "그루비룸")
    private String groupName;

    private LocalDate startDate;
    private LocalDate endDate;

    @Schema(name = "theme", example = "여행 테마")
    private String theme;
}
