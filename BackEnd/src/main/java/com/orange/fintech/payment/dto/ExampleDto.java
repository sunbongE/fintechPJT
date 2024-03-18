package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(name = "Example", description = "예제입니다.")
public class ExampleDto {

    @Schema(name = "1번", example = "string 입력")
    String tmpString;

    @Schema(name = "2번", example = "1")
    int tmpInt;
}
