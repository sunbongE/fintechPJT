package com.orange.fintech.payment.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "거래내역 수정 요청 Dto")
public class TransactionEditReq {

    @Schema(description = "거래내역 메모")
    String memo;

    @Schema(description = "거래에 참여하는 멤버 목록")
    List<TransactionMemberDto> memberList;
}
